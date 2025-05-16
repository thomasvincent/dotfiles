# Contributing to Dotfiles

Thank you for considering contributing to this dotfiles repository\! Your input and improvements are valuable to make this configuration better for everyone.

## How to Contribute

### Reporting Issues

If you encounter any issues or have suggestions for improvements, please open an issue with a clear description of:

- What the problem is
- Steps to reproduce the issue
- Expected behavior
- Your environment (OS, shell version, etc.)

### Pull Requests

1. Fork the repository
2. Create a new branch for your changes (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Run the tests: `make test` and `make lint`
5. Commit your changes with a meaningful commit message using conventional commit format
6. Push to your fork and submit a pull request

### Code Style

- Follow the existing code style in the project
- Use meaningful function and variable names
- Add comments for complex logic
- Keep functions focused on a single responsibility
- For shell scripts, follow [Google's Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for commit messages:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Changes that don't affect code functionality (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `perf`: Performance improvements
- `test`: Adding or fixing tests
- `chore`: Changes to build process or auxiliary tools

### Testing

Before submitting a PR, please:

1. Test your changes on both macOS and Linux if applicable
2. Run `make test` to ensure your changes don't break shell startup
3. Run `make lint` to check code quality

## Code of Conduct

Please be respectful and considerate when contributing. We aim to foster an inclusive and welcoming community.

## License

By contributing to this repository, you agree that your contributions will be licensed under the same license as the project.
EOF < /dev/null