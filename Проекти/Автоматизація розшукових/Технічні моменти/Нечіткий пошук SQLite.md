1. Модель
```
public class Post
{
    public int Id { get; set; }
    public string Content { get; set; } = null!;
}

// FTS-віртуальна таблиця (тільки для пошуку)
public class FtsPost
{
    public int RowId { get; set; }
    public string Content { get; set; } = null!;
}
```

2. DbContext
```
using Microsoft.EntityFrameworkCore;

public class AppDbContext : DbContext
{
    public DbSet<Post> Posts => Set<Post>();
    public DbSet<FtsPost> FtsPosts => Set<FtsPost>();

    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseSqlite("Data Source=app.db");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<FtsPost>()
            .HasNoKey()
            .ToTable("FtsPosts"); // virtual table
    }
}
```

3. Міграція (створюємо FTS5)
```
protected override void Up(MigrationBuilder migrationBuilder)
{
    // Таблиця FTS5 з триґрамами
    migrationBuilder.Sql(@"
        CREATE VIRTUAL TABLE FtsPosts
        USING fts5(Content, content='Posts', content_rowid='Id', tokenize='trigram');
    ");

    // Тригери для синхронізації
    migrationBuilder.Sql(@"
        CREATE TRIGGER posts_ai AFTER INSERT ON Posts BEGIN
          INSERT INTO FtsPosts(rowid, Content) VALUES (new.Id, new.Content);
        END;
    ");
    migrationBuilder.Sql(@"
        CREATE TRIGGER posts_ad AFTER DELETE ON Posts BEGIN
          INSERT INTO FtsPosts(FtsPosts, rowid, Content) VALUES('delete', old.Id, old.Content);
        END;
    ");
    migrationBuilder.Sql(@"
        CREATE TRIGGER posts_au AFTER UPDATE ON Posts BEGIN
          INSERT INTO FtsPosts(FtsPosts, rowid, Content) VALUES('delete', old.Id, old.Content);
          INSERT INTO FtsPosts(rowid, Content) VALUES (new.Id, new.Content);
        END;
    ");
}

protected override void Down(MigrationBuilder migrationBuilder)
{
    migrationBuilder.Sql("DROP TABLE FtsPosts;");
}
```

4. Використання
```
using var db = new AppDbContext();

// Додати дані
db.Database.EnsureCreated();
if (!db.Posts.Any())
{
    db.Posts.AddRange(
        new Post { Content = "Entity Framework Core з SQLite" },
        new Post { Content = "EF Core підтримує FTS5 пошук" },
        new Post { Content = "Full Text Search у SQLite" }
    );
    db.SaveChanges();
}

// Пошук через FTS5
string term = "SQLite";
var results = db.Posts
    .FromSqlRaw(@"
        SELECT p.*
        FROM Posts p
        JOIN FtsPosts f ON f.rowid = p.Id
        WHERE f.Content MATCH {0}", term)
    .ToList();

foreach (var r in results)
    Console.WriteLine(r.Content);
```