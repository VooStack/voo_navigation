# voo_navigation

A comprehensive, adaptive navigation package suite for Flutter that automatically adjusts to different screen sizes and platforms with Material 3 design.

## Packages

| Package | Version | Description |
|---------|---------|-------------|
| [voo_navigation](packages/ui/voo_navigation) | 1.2.0 | Main orchestration package - re-exports all sub-packages |
| [voo_navigation_core](packages/ui/voo_navigation_core) | 0.1.0 | Shared foundation - entities, atoms, molecules, utilities |
| [voo_navigation_rail](packages/ui/voo_navigation_rail) | 0.1.0 | Rail navigation components |
| [voo_navigation_drawer](packages/ui/voo_navigation_drawer) | 0.1.0 | Drawer navigation components |
| [voo_navigation_bar](packages/ui/voo_navigation_bar) | 0.1.0 | Bottom navigation bar components |

## Architecture

```
voo_navigation_core (v0.1.0)
       ↑
       ├──────────────┬──────────────┐
       ↑              ↑              ↑
voo_navigation_rail  voo_navigation_drawer  voo_navigation_bar
   (v0.1.0)              (v0.1.0)              (v0.1.0)
       ↑              ↑              ↑
       └──────────────┴──────────────┘
                      ↑
               voo_navigation (v1.2.0)
```

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  voo_navigation: ^1.2.0
```

Or import individual packages:

```yaml
dependencies:
  voo_navigation_core: ^0.1.0
  voo_navigation_rail: ^0.1.0
```

## Development

This project uses [Melos](https://melos.invertase.dev/) for monorepo management.

```bash
# Install dependencies
melos bootstrap

# Run tests
melos run test_all

# Analyze code
melos run analyze

# Clean build artifacts
melos run clean
```

## License

MIT License - see individual packages for details.
