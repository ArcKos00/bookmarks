https://habr.com/ru/articles/883678/


[Obsidian](https://www.youtube.com/watch?v=4zWU4umAMoc&feature=youtu.be) is one of the best note-taking apps available today. It provides a powerful, Markdown-based experience with local-first storage. However, there is one problem: the official sync feature costs around $8 per month. What if I told you there’s a way to sync your notes across multiple devices completely free? In this guide, I will walk you through a method using GitHub and Git that allows you to keep your notes in sync without spending a dime.

![How to Sync Obsidian Notes Across Devices](https://habrastorage.org/r/w780/getpro/habr/upload_files/938/7fd/566/9387fd5669e3d998194a876665948386.png)

How to Sync Obsidian Notes Across Devices

### What Would Need

It could feel that you need to do a lot of things, but don't worry in an ideal scenario, you would need about 10-15 minutes and these things:

- GitHub Account & Repository
- GitHub Access Token
- SSH key (optional)
- Git
- Obsidian
- Git Plugin for Obsidian
- iSH app for iPhone
- Obsidian App for iPhone

### Step 1: Create a GitHub Account and Repository

**GitHub** is a cloud-based platform primarily used for software development, but it can also be used for managing personal projects and files—including Obsidian notes.

![](https://habrastorage.org/r/w780/getpro/habr/upload_files/779/273/dfd/779273dfd6abb5abaa29d7edf50783ce.png)

A **Git repository** (or repo) is a storage space where Git tracks all the changes to a set of files. It records modifications, allowing you to revert to previous versions, collaborate with others, and synchronize your files across different devices. In the context of Obsidian, a Git repository helps store and sync your notes while keeping track of all edits.

1. Go to [GitHub.com](https://github.com/) and sign up.
2. Once logged in, click on the **New** button to create a new repository.
3. Give it a name (e.g., "Obsidian-Notes").
4. Make sure to set the repository to **Private** so your notes are not publicly accessible.
5. Click **Create Repository**.
![Git repository](https://habrastorage.org/r/w780/getpro/habr/upload_files/007/84d/f6a/00784df6ad7f854602ba7bccb71e95f8.png)

Git repository

### Step 2: Install Git on Your Computer

If you don’t have Git installed, follow these steps:

- **Windows**: Download and install Git from [git-scm.com.](https://git-scm.com/)
- **Mac**: Install Git using Homebrew with `brew install git`.
- **Linux**: Use `sudo apt-get install git` (for Debian-based systems) or sudo dnf install git (for Fedora-based systems).

Once installed, open your terminal (Command Prompt, PowerShell, or macOS Terminal) and verify installation by running:

```bash
git --version
```

#### Basic Git Commands

Here are three essential Git commands that you’ll use frequently:

```bash
git status
```

This command shows the current state of your repository. It tells you which files have been modified, added, or staged for commit.git status

```bash
git pull
```

This command fetches the latest changes from the remote repository (GitHub) and updates your local repository.

```bash
git push
```

After making changes, you need to upload them to GitHub using git push. This command sends your committed changes from your local repository to the remote repository.

### Step 3: Clone the GitHub Repository

Now, let’s connect your local Obsidian vault to GitHub:

- Open your terminal and navigate to the folder where you want to store your notes.
- Run the following command, replacing YOUR-REPO-URL with your GitHub repository URL:
```bash
git clone YOUR-REPO-URL
```
- This will create a local folder linked to your GitHub repository.
	![Clone the GitHub Repository](https://habrastorage.org/r/w780/getpro/habr/upload_files/b53/b2d/295/b53b2d295bce6ad0e0124861911a4de2.png)
	Clone the GitHub Repository

Move your Obsidian notes into this folder so they are ready for syncing.

### Step 3. How to Get a GitHub Classic Token

GitHub has deprecated password-based authentication for Git operations. Instead, it requires you to use a **Personal Access Token (PAT)**, which provides a more secure way to authenticate.

![How to Get a GitHub Classic Token](https://habrastorage.org/r/w780/getpro/habr/upload_files/b9e/2c7/561/b9e2c7561faf7995f04cb11b9b40d3a7.png)

How to Get a GitHub Classic Token

1. **Go to GitHub Developer Settings:**
	- Open [GitHub Token Settings](https://github.com/settings/tokens).
	- Click **Generate new token** → Select **Classic**.
2. **Set Expiration & Permissions:**
	- Choose an expiration date or set it to **No Expiration** (not recommended for security).
	- Select the necessary scopes:
		- repo → For accessing private repositories.
3. **Generate and Copy the Token:**
	- Click **Generate token** and **copy it immediately**.
	- GitHub won’t show it again after you leave the page.
4. **Use the Token in Git Authentication:**
	- When prompted for a **password** in Git operations, paste the token instead.

### Step 4: Set Up SSH for Authentication (optional)

To avoid entering your password every time you sync, you can set up SSH authentication:

- Generate an SSH key by running:
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```
- Copy the SSH key using:
```
cat ~/.ssh/id_ed25519.pub
```
- Go to GitHub, navigate to **Settings > SSH and GPG keys**, and add the copied key.
![Set Up SSH for Authentication (Optional)](https://habrastorage.org/r/w780/getpro/habr/upload_files/14f/d1c/f99/14fd1cf9979d6673a9ca626b0d2cac9b.png)

Set Up SSH for Authentication (Optional)

Now, your system will authenticate with GitHub automatically.

### Step 5: Set Up Git Plugin in Obsidian

I assume you already have the Obsidian App, which is why I won't cover the installation process for it here. I will only show you quick steps to install the Git plugin.

Obsidian has a plugin that makes Git syncing easier:

1. Open Obsidian and go to **Settings > Community Plugins**.
2. Search for "Git" and install it.
3. Enable **Auto Commit and Sync** (set an interval, e.g., 5 minutes).
4. Enable **Pull on Startup** to prevent conflicts.
	![Set Up Git Plugin in Obsidian](https://habrastorage.org/r/w780/getpro/habr/upload_files/fa1/d8a/f85/fa1d8af8524fc1898c7cf12f433fe6e0.png)
	Set Up Git Plugin in Obsidian

Now, whenever you edit notes, Obsidian will sync them automatically with GitHub.

### Step 6: Syncing Notes on Mobile (iOS, iPhone, iPad)

Syncing on mobile is slightly more complicated but still doable.

- Install **Obsidian** from the App Store.
- Install **iSH**, a terminal app that allows running Linux commands.
	![iSH App](https://habrastorage.org/r/w780/getpro/habr/upload_files/8c3/201/b86/8c3201b86b45c7f0539ae35dd3d97e25.png)
	iSH App
- Open iSH and install Git using:
```bash
apk add git
```
- Create a folder for your obsidian notes:
```bash
mkdir obsidian
```
- Run mount command to mount obsidian vault folder
```bash
mount -t ios . obsidian
```
- A file picker will show up. Choose the folder with your local vault.
- Then use the following commands:
```
cd obsidian
rm -rf .
git clone YOUR-REPO-URL .
```

Once this step is done you will see your notes in the Obsidian application.

![Obsidian iOS](https://habrastorage.org/r/w780/getpro/habr/upload_files/422/74e/d52/42274ed52ac64adfc9f1bc106043793c.png)

Obsidian iOS

### Step 7: Install Obsidian Git Plugin on iPhone

The last step in our tutorial - Git community plugin.

- Open Obsidian.
- Go to Settings > Community Plugins.
- Tap Browse and search for Obsidian Git.
- Tap Install, then Enable the plugin.
- Set up an auto-commit interval (e.g., every 5 minutes).
- Enable Pull on Startup to sync changes when opening Obsidian.
![Git Plugin](https://habrastorage.org/r/w780/getpro/habr/upload_files/443/bb3/efc/443bb3efcd9e73166466e79eab7b478c.png)

Git Plugin

### Video Tutorial

If you are struggling with the steps, I recommend you to watch my detailed video tutorial.

*Watch on YouTube:* [*Obsidian Sync Tutorial*](https://youtu.be/PScdHzUiBLA?si=irQnCWpxIgJQN4-k)

### Conclusion

While it takes a bit of setup, once done, it works seamlessly. If you found this guide helpful, let me know in the comments, and feel free to ask any questions!

Cheers!;)

0

Чай, тортик и код: с Днём программиста!

Made in AI

Чего хотят лиды в бигтехе?

Как расти в ИТ: советы, гайды и опыт сеньоров

Курсы со скидками до 60%
