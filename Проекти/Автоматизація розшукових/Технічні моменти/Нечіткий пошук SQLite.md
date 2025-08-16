1. 
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

