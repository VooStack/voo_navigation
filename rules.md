# VooStack Coding Rules

This document defines the mandatory coding rules and standards for the FlightStack project.

**IMPORTANT**: All Claude Code sessions must follow these rules. CLAUDE.md references this file.

## Core Principles

### 0. KISS (Keep It Simple, Stupid) - The Prime Directive
- **Simplicity above all else**: Every solution should be as simple as possible, but no simpler
- **Avoid over-engineering**: Don't add complexity for hypothetical future needs
- **Clear over clever**: Readable, maintainable code beats clever one-liners
- **When in doubt, choose the simpler approach**: If two solutions work, pick the simpler one

**Examples:**
```dart
// BAD: Over-engineered
abstract class AbstractFactoryProvider<T> {
  T create();
}
class RepositoryFactoryProvider extends AbstractFactoryProvider<Repository> {
  @override
  Repository create() => RepositoryImpl();
}

// GOOD: Simple and direct
class RepositoryProvider {
  Repository createRepository() => RepositoryImpl();
}

// BAD: Clever but confusing
final items = list
  ..addAll(newItems)
  ..sort((a, b) => a.date.compareTo(b.date));

// GOOD: Clear and explicit
final items = [...list, ...newItems];
items.sort((a, b) => a.date.compareTo(b.date));
```

### 1. Planning & Task Management
- **Always plan before implementation**: Read relevant code, understand the context, create a detailed todo list
- **Use tasks/todo.md for tracking**: Document all planned changes with checkboxes
- **Get approval before major changes**: Present plan to maintainers before proceeding
- **Mark tasks as complete progressively**: Update status as work progresses, not in batches

### 2. Atomic Design
Every component should be atomic - small, focused, and doing one thing well.

**Rules:**
- Functions should be < 50 lines (exceptions allowed for complex widgets)
- Classes should have a single responsibility
- Extract complex logic into separate functions or classes
- Prefer many small files over few large files

**Example:**
```dart
// BAD: Complex widget doing too much
class ComplexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(/* 20 lines */),
      body: Column(
        children: [
          // 100 lines of nested widgets
        ],
      ),
    );
  }
}

// GOOD: Atomic components
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(),
      body: _MyPageBody(),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Focused on app bar only
}

class _MyPageBody extends StatelessWidget {
  // Focused on body content
}
```

### 3. One Class Per File
Each file should contain exactly ONE public class.

**Rules:**
- Allowed: Private implementation classes (e.g., `_MyWidgetState` with `MyWidget`)
- Allowed: Sealed class hierarchies in domain models (e.g., events/states in same file)
- Forbidden: Multiple unrelated public classes
- Forbidden: UI components in non-UI files (e.g., screens in router file)

**Examples:**
```dart
// GOOD: Widget and its state
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // Private implementation
}

// GOOD: Sealed class hierarchy
sealed class MyEvent extends Equatable {}
class LoadData extends MyEvent {}
class UpdateData extends MyEvent {}

// BAD: Multiple unrelated classes
class ScreenA extends StatelessWidget {}
class ScreenB extends StatelessWidget {}
class ScreenC extends StatelessWidget {}
```

## Naming Conventions

### File Naming Rules
- **Use snake_case**: All Dart files must use snake_case
  - `data_grid.dart`, `user_profile_widget.dart`
  - NOT `DataGrid.dart`, `userProfileWidget.dart`
- **Match class names**: File names should match the primary class they contain
  - File `user_profile_widget.dart` contains class `UserProfileWidget`
- **Descriptive suffixes**: Use appropriate suffixes for clarity
  - Widgets: `_widget.dart` (e.g., `button_widget.dart`)
  - Screens/Pages: `_screen.dart` or `_page.dart`
  - Models: `_model.dart`
  - Services: `_service.dart`
  - Repositories: `_repository.dart`
  - Controllers: `_controller.dart`
  - Utils: `_utils.dart`
- **Test files**: Must end with `_test.dart` and mirror source structure
  - Source: `lib/src/widgets/button_widget.dart`
  - Test: `test/src/widgets/button_widget_test.dart`

### Class Naming Rules
- **Use PascalCase**: All classes must use PascalCase
  - `UserProfileWidget`, `DataGridController`
  - NOT `userProfileWidget`, `data_grid_controller`
- **Descriptive suffixes**: Clearly indicate the class purpose
  - Widgets: `*Widget` (e.g., `ButtonWidget`, `HeaderWidget`)
  - Controllers: `*Controller`
  - Services: `*Service`
  - Repositories: `*Repository`
  - Models: `*Model` or just descriptive name (e.g., `User`, `Product`)
  - BLoCs: `*Bloc`
  - Cubits: `*Cubit`
- **Interface naming**: Prefix abstract classes with `I` or use descriptive names
  - `IUserRepository`, `BaseWidget`, `AbstractService`

### Widget Naming Rules
- **Atomic Design Folder Structure Only**:
  - Atomic design level is indicated ONLY by folder structure
  - Files and classes should NOT contain `atom`, `molecule`, or `organism` suffixes
  - Folder structure: `atoms/`, `molecules/`, `organisms/`, `templates/`, `pages/`
  - Example structure:
    ```
    presentation/
    ├── atoms/
    │   └── button_widget.dart (contains class ButtonWidget)
    ├── molecules/
    │   └── search_bar.dart (contains class SearchBar)
    └── organisms/
        └── header.dart (contains class Header)
    ```
- **File and Class Naming**:
  - Folder: `atoms/` -> File: `button_widget.dart` -> Class: `ButtonWidget`
  - Folder: `molecules/` -> File: `form_section.dart` -> Class: `FormSection`
  - Folder: `organisms/` -> File: `voo_form.dart` -> Class: `VooForm`
  - NOT: File: `button_atom.dart` (Don't add atomic suffix to files)
  - NOT: Class: `ButtonAtom` (Don't add atomic suffix to classes)
- **Component clarity**: Name should immediately convey purpose
  - `UserAvatarWidget`, `NavigationDrawer`
  - NOT `Avatar`, `Drawer` (too generic)

### Variable & Method Naming Rules
- **Use camelCase**: All variables and methods use camelCase
  - `userName`, `getUserData()`, `isLoading`
  - NOT `user_name`, `GetUserData()`, `IsLoading`
- **Boolean naming**: Prefix with `is`, `has`, `can`, `should`
  - `isLoading`, `hasError`, `canEdit`, `shouldRefresh`
  - NOT `loading`, `error`, `editable`
- **Private members**: Prefix with underscore
  - `_controller`, `_calculateTotal()`
- **Constants**: Use lowerCamelCase (preferred in Dart)
  - `const maxRetryCount = 3`

### Package & Directory Naming Rules
- **Use snake_case**: All directories and packages use snake_case
  - `flightstack_core`, `data_grid`, `user_management`
  - NOT `FlightstackCore`, `dataGrid`, `UserManagement`
- **Logical grouping**: Group by feature or layer
  - By feature: `features/authentication/`, `features/shopping_cart/`
  - By layer: `presentation/`, `domain/`, `data/`

### Enum Naming Rules
- **Use PascalCase**: Enum types use PascalCase
  - `enum UserRole { admin, user, guest }`
- **Values use camelCase**: Enum values should be camelCase
  - `UserStatus.active`, `UserStatus.inactive`

### Extension Methods Rule
Display logic, formatting, and utility methods related to enums or model classes **MUST** be placed in dedicated extension files, not scattered throughout widget files.

**File Naming:**
- Extension files: `{type_name}_extensions.dart` (snake_case)
- Place in the same directory as the enum/class being extended
- Example: `pipeline_job_run_status_extensions.dart` for `PipelineJobRunStatus` enum

**What belongs in extension files:**
- Display names (`displayName`, `label`)
- Color mappings (`color`, `statusColor`)
- Icon mappings (`icon`, `statusIcon`)
- Formatting methods (`formattedDuration`, `displayText`)
- Any UI-related conversion logic

**Example:**
```dart
// BAD: Display logic scattered in widget files
class _JobNodeState extends State<_JobNode> {
  Color _getStatusColor(ThemeData theme) {
    switch (widget.jobRun.status) {
      case PipelineJobRunStatus.running:
        return theme.colorScheme.primary;
      case PipelineJobRunStatus.success:
        return Colors.green;
      // ... more cases
    }
  }
}

// GOOD: Extension file (pipeline_job_run_status_extensions.dart)
extension PipelineJobRunStatusX on PipelineJobRunStatus {
  Color color(ThemeData theme) {
    return switch (this) {
      PipelineJobRunStatus.running => theme.colorScheme.primary,
      PipelineJobRunStatus.success => Colors.green,
      PipelineJobRunStatus.failed => Colors.red,
      PipelineJobRunStatus.cancelled => Colors.orange,
      PipelineJobRunStatus.skipped => Colors.orange,
      _ => theme.colorScheme.outline,
    };
  }

  String get displayName {
    return switch (this) {
      PipelineJobRunStatus.pending => 'Pending',
      PipelineJobRunStatus.running => 'Running',
      PipelineJobRunStatus.success => 'Success',
      PipelineJobRunStatus.failed => 'Failed',
      // ... etc
    };
  }
}

// Usage in widget - clean and readable
Container(
  color: status.color(theme),
  child: Text(status.displayName),
)
```

**Benefits:**
- Single source of truth for display logic
- Eliminates duplicated switch statements across widgets
- Easy to maintain consistent colors/icons/labels app-wide
- Keeps widget files focused on layout and behavior
- Changes to display logic only require editing one file

### File Refactoring Rules
- **No v2 or optimized naming**: When refactoring a file, ALWAYS replace the original file
  - NEVER create `data_grid_v2.dart` or `optimized_data_grid.dart`
  - ALWAYS replace the existing `data_grid.dart` directly
  - Old versions belong in git history, not in the codebase

### Import Rules
- **No relative imports**: Always use absolute imports from package root
- **Package imports first**: Order imports as dart, flutter, package, then local
- **Avoid naming imports unless necessary**: Only use `as` for conflicts
  - `import 'package:flutter/material.dart';`
  - `import 'package:http/http.dart' as http;` (only if needed)

## Project Structure Rules

### Directory Organization
```
lib/
├── app/                         # Application-level code
│   ├── app.dart                # Root widget
│   ├── router.dart             # Route definitions ONLY
│   ├── state_providers.dart    # DI setup
│   ├── app_constants.dart      # Constants
│   └── widgets/                # App-level widgets (ErrorScreen, etc.)
├── core/                        # Shared functionality
│   ├── data/                   # Base classes, database
│   ├── domain/                 # Shared entities
│   └── presentation/           # Shared UI (theme, mixins, widgets)
└── features/                    # Feature modules
    └── feature_name/
        ├── data/               # Models, repositories, sources
        ├── domain/             # Entities, repository interfaces
        └── presentation/       # UI (pages, widgets, state)
```

**Rules:**
- Router file contains ONLY routing logic - no UI components
- Each feature is self-contained with its own data/domain/presentation
- Cross-feature dependencies should go through core/
- Widgets used by multiple features go in core/presentation/widgets/

## Clean Architecture Rules

### Layer Separation
Each layer has specific responsibilities and dependencies.

**Dependency Rule:** Inner layers NEVER depend on outer layers.
```
Presentation -> Domain <- Data
```

**Domain Layer Rules:**
- No Flutter dependencies (no `BuildContext`, `Widget`, etc.)
- No external package dependencies (except Dart core)
- Only pure Dart entities and abstract interfaces
- No implementation details

**Data Layer Rules:**
- Depends on domain (implements domain interfaces)
- Contains models, not entities
- Handles JSON serialization, API calls, database queries
- Converts models to entities before returning to domain

**Presentation Layer Rules:**
- Depends on domain (uses entities and repository interfaces)
- Never imports from data layer directly
- Contains widgets, pages, BLoCs
- Gets repository instances via dependency injection

**Example:**
```dart
// domain/entities/user.dart
class User extends Equatable {
  final String id;
  final String name;
  const User({required this.id, required this.name});
  @override
  List<Object?> get props => [id, name];
}

// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<User> getUser(String id);
}

// data/models/user_model.dart
@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  UserModel({required this.id, required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  User toEntity() => User(id: id, name: name);
}

// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  final UserAPI _api;
  UserRepositoryImpl(this._api);

  @override
  Future<User> getUser(String id) async {
    final model = await _api.getUser(id);
    return model.toEntity(); // Convert model to entity
  }
}
```

## Code Quality Standards

### Immutability
All domain entities and BLoC states must be immutable.

**Rules:**
- Use `final` for all class fields
- Use `const` constructors where possible
- Never expose mutable collections - use `UnmodifiableListView` if needed
- Extend `Equatable` for value equality

### Null Safety
Embrace sound null safety - no `!` unless absolutely necessary.

**Rules:**
- Use nullable types (`Type?`) when value can be null
- Use `??` and `?.` operators instead of `!`
- Only use `!` when you can prove the value is non-null
- Prefer `late` over nullable for fields initialized in lifecycle methods

**Example:**
```dart
// BAD: Unsafe null handling
final name = user!.name!.toUpperCase();

// GOOD: Safe null handling
final name = user?.name?.toUpperCase() ?? 'Unknown';
```

### Error Handling
Handle errors explicitly and provide meaningful feedback.

**Rules:**
- Always catch specific exceptions, not generic `Exception`
- Provide user-friendly error messages
- Log errors with context
- Never silently catch and ignore errors
- Create custom exceptions for domain errors

**Example:**
```dart
// GOOD: Explicit error handling
try {
  final data = await repository.getData(id);
  emit(DataLoaded(data));
} on NetworkException catch (e) {
  logger.e('Network error loading data', error: e);
  emit(DataError('Unable to connect. Check your internet connection.'));
} on NotFoundException catch (e) {
  logger.w('Data not found: $id', error: e);
  emit(DataError('The requested item was not found.'));
} catch (e, stackTrace) {
  logger.e('Unexpected error loading data', error: e, stackTrace: stackTrace);
  emit(DataError('An unexpected error occurred. Please try again.'));
}

// BAD: Generic error handling
try {
  final data = await repository.getData(id);
  emit(DataLoaded(data));
} catch (e) {
  emit(DataError(e.toString())); // Exposes implementation details to user
}
```

### Resource Management
Always dispose resources to prevent memory leaks.

**Rules:**
- Dispose `ScrollController`, `TextEditingController`, `AnimationController`
- Close `StreamController`, `StreamSubscription`
- Cancel `Timer` instances
- Stop and dispose hub connections
- Call `super.dispose()` last

**Example:**
```dart
class _MyWidgetState extends State<MyWidget> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  StreamSubscription? _subscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _subscription = someStream.listen((data) {});
    _timer = Timer.periodic(Duration(seconds: 1), (_) {});
  }

  @override
  void dispose() {
    // Dispose in reverse order of creation
    _timer?.cancel();
    _subscription?.cancel();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose(); // Always last
  }
}
```

### Zero Lint Issues Policy
- Never commit code with lint warnings or errors
- Run `flutter analyze` before every commit
- Fix all warnings, not just errors
- Use `flutter analyze --fatal-warnings` in CI/CD

## State Management Rules (BLoC)

### BLoC Scope Rule
**BLoCs must be provided locally, not globally.** Each page/feature that needs a BLoC should create its own instance via `BlocProvider`. This ensures:
- Proper lifecycle management (BLoC disposed when page closes)
- No state pollution between different screens
- Clear ownership and testability

```dart
// GOOD: Local BLoC provider in the page
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBloc(
        repository: context.read<MyRepository>(),
      )..add(const LoadData()),
      child: const _MyPageContent(),
    );
  }
}

// BAD: Global BLoC provider in app/router
MultiBlocProvider(
  providers: [
    BlocProvider<MyBloc>(create: (_) => MyBloc()), // Don't do this
  ],
  child: MaterialApp(...),
)
```

### Status-Based State Pattern (Required)
Use a **single state class with a status enum** instead of multiple sealed state classes. This reduces boilerplate, makes state transitions clearer, and allows preserving data across status changes.

```dart
// Status enum (in state.dart)
enum MyStatus {
  initial,
  loading,
  success,
  error,
}

// Single state class (in state.dart)
class MyState extends Equatable {
  final MyStatus status;
  final List<Item> items;
  final Item? selectedItem;
  final String? errorMessage;

  const MyState({
    this.status = MyStatus.initial,
    this.items = const [],
    this.selectedItem,
    this.errorMessage,
  });

  /// Use copyWith for immutable state updates
  MyState copyWith({
    MyStatus? status,
    List<Item>? items,
    Item? selectedItem,
    String? errorMessage,
  }) => MyState(
    status: status ?? this.status,
    items: items ?? this.items,
    selectedItem: selectedItem ?? this.selectedItem,
    errorMessage: errorMessage,
  );

  @override
  List<Object?> get props => [status, items, selectedItem, errorMessage];
}

// Events (Sealed class in event.dart)
sealed class MyEvent extends Equatable {
  const MyEvent();
}

class LoadItems extends MyEvent {
  final String projectId;
  const LoadItems({required this.projectId});
  @override
  List<Object?> get props => [projectId];
}

class DeleteItem extends MyEvent {
  final String id;
  const DeleteItem({required this.id});
  @override
  List<Object?> get props => [id];
}

// BLoC (in bloc.dart)
class MyBloc extends Bloc<MyEvent, MyState> {
  final MyRepository _repository;

  MyBloc({required MyRepository repository})
      : _repository = repository,
        super(const MyState()) {
    on<LoadItems>(_onLoadItems);
    on<DeleteItem>(_onDeleteItem);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<MyState> emit) async {
    emit(state.copyWith(status: MyStatus.loading));
    try {
      final items = await _repository.getItems(event.projectId);
      emit(state.copyWith(status: MyStatus.success, items: items));
    } catch (e) {
      emit(state.copyWith(status: MyStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteItem(DeleteItem event, Emitter<MyState> emit) async {
    emit(state.copyWith(status: MyStatus.loading));
    try {
      await _repository.deleteItem(event.id);
      final updatedItems = state.items.where((i) => i.id != event.id).toList();
      emit(state.copyWith(status: MyStatus.success, items: updatedItems));
    } catch (e) {
      emit(state.copyWith(status: MyStatus.error, errorMessage: e.toString()));
    }
  }
}
```

### Using Status-Based State in UI

```dart
class _MyPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyBloc, MyState>(
      listener: (context, state) {
        if (state.status == MyStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        if (state.status == MyStatus.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: state.items.length,
          itemBuilder: (context, index) => ItemTile(item: state.items[index]),
        );
      },
    );
  }
}
```

**BLoC Rules:**
- **Use status enum pattern** - Single state class with status field, NOT multiple sealed state classes
- **Provide BLoCs locally** - Create in page widget, not globally
- Events must be immutable and extend `Equatable`
- Use sealed classes for events only
- One event handler per event type
- Use `state.copyWith()` for immutable state updates
- Preserve data across status changes when appropriate
- Never perform UI operations in BLoC (no navigation, dialogs, etc.)
- Keep BLoCs focused - split if > 10 event handlers

## Widget Rules

### Widget Development Rules
- **Reuse Existing Widgets First**:
  - ALWAYS check for existing widgets in `lib/core/presentation/widgets/` before creating new ones
  - Prefer composition and extension over duplication
  - Common widgets to reuse: FSListView, FSButton, FSAppBar, FSTextField, etc.
  - Only create custom widgets when existing ones cannot be adapted
- **Atomic Design Pattern**:
  - Atoms: Basic UI elements
  - Molecules: Simple component groups
  - Organisms: Complex component sections
- **One class per file**: Each class should be in its own file
- **No function widgets**: Always use proper widget classes
- **No _buildXXX methods**: DO NOT use methods like _buildSwitchField that return widgets
  - Instead, create separate widget classes following atomic design
  - Each widget type should be in its own file
  - This improves code readability and maintainability
- **No private widget classes in other files**: DO NOT define private widget classes like `_DrawerHeader` inside another widget's file
  - Each widget must be in its OWN file with a descriptive name
  - Private widgets should still be separate files, just with underscore prefix in class name if internal
  - **FORBIDDEN pattern:**
    ```dart
    // BAD: Private widget class embedded in another file
    // File: voo_adaptive_navigation_drawer.dart
    class VooAdaptiveNavigationDrawer extends StatefulWidget { ... }

    class _DrawerHeader extends StatelessWidget { ... }  // NO! Separate file!
    class _DrawerSearchBar extends StatelessWidget { ... }  // NO! Separate file!
    ```
  - **CORRECT pattern:**
    ```dart
    // File: drawer_header.dart (or voo_drawer_header.dart)
    class VooDrawerHeader extends StatelessWidget { ... }

    // File: drawer_search_bar.dart (or voo_drawer_search_bar.dart)
    class VooDrawerSearchBar extends StatelessWidget { ... }

    // File: voo_adaptive_navigation_drawer.dart
    // Only contains VooAdaptiveNavigationDrawer, imports the above
    ```
  - **Why this matters:**
    - Files become too large and hard to navigate
    - Widgets cannot be reused across other files
    - Violates atomic design principle of one component per file
    - Makes testing individual widgets difficult
- **No `_*Content` delegation pattern**: DO NOT create a shell page that only provides a BlocProvider and delegates to a private `_*Content` widget
  - **FORBIDDEN pattern:**
    ```dart
    // BAD: Shell page + private content widget
    class MyPage extends StatelessWidget {
      @override
      Widget build(BuildContext context) => BlocProvider(
        create: (context) => MyBloc(),
        child: const _MyPageContent(), // All logic hidden here!
      );
    }

    class _MyPageContent extends StatefulWidget { /* 500+ lines */ }
    ```
  - **CORRECT pattern:** Make the page itself stateful and contain all the logic:
    ```dart
    // GOOD: Single page class with BlocProvider in build
    class MyPage extends StatefulWidget {
      @override
      State<MyPage> createState() => _MyPageState();
    }

    class _MyPageState extends State<MyPage> {
      // All state and logic here

      @override
      Widget build(BuildContext context) => BlocProvider(
        create: (context) => MyBloc(),
        child: BlocConsumer<MyBloc, MyState>(
          // UI here directly
        ),
      );
    }
    ```
  - **Why this matters:**
    - Private `_*Content` widgets hide complexity and make files harder to understand
    - The "shell" page provides no value - it's just boilerplate
    - Testing becomes harder when logic is split across classes
  - **Exception:** ONLY `_*State` classes for StatefulWidget are allowed in the same file
- **No static widget creation methods**: Avoid static methods for creating widgets or form fields
  - Use factory constructors instead
- **Stateless when possible**: Only use StatefulWidget when necessary
- **Theme compliance**: Use app theme for all styling

### Widget Construction
```dart
// GOOD: Proper widget structure
class MyWidget extends StatelessWidget {
  // 1. Fields (final, required first)
  final String title;
  final VoidCallback? onTap;

  // 2. Constructor (const when possible)
  const MyWidget({
    required this.title,
    this.onTap,
    super.key,
  });

  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(title),
    );
  }
}
```

**Widget Rules:**
- Use `const` constructors whenever possible
- Required parameters first, optional second
- Always include `super.key`
- Extract complex widget trees into separate widgets
- Prefer `StatelessWidget` over `StatefulWidget` when possible
- Use `ListView.builder` for long lists

### BLoC Integration
```dart
// GOOD: BLoC in widget
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBloc(context.read<MyRepository>()),
      child: const _MyPageContent(),
    );
  }
}

class _MyPageContent extends StatelessWidget {
  const _MyPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBloc, MyState>(
      builder: (context, state) {
        return switch (state) {
          MyLoading() => const CircularProgressIndicator(),
          MyLoaded(data: final data) => _buildContent(data),
          MyError(message: final msg) => _buildError(msg),
          _ => const SizedBox(),
        };
      },
    );
  }
}
```

## Testing Requirements

### Test Coverage
- **Test coverage minimum**: 80% for business logic
- **Unit tests required**: For all repository implementations
- **Widget tests required**: For all custom widgets
- **Integration tests**: For critical user flows
- **Mock dependencies**: Use Mockito for dependency mocking

### Test Structure
```dart
void main() {
  group('MyBloc', () {
    late MyBloc bloc;
    late MockMyRepository repository;

    setUp(() {
      repository = MockMyRepository();
      bloc = MyBloc(repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is MyInitial', () {
      expect(bloc.state, const MyInitial());
    });

    blocTest<MyBloc, MyState>(
      'emits [MyLoading, MyLoaded] when LoadData succeeds',
      build: () => bloc,
      act: (bloc) => bloc.add(const LoadData('123')),
      expect: () => [
        const MyLoading(),
        MyLoaded(mockData),
      ],
    );
  });
}
```

## Performance Guidelines

1. **Avoid rebuilds**: Use `const` widgets, `RepaintBoundary`, and proper BLoC selectors
2. **Lazy loading**: Use pagination, don't load all data at once
3. **Dispose resources**: Always clean up controllers, streams, timers
4. **Optimize images**: Use appropriate image formats and caching
5. **Minimize dependencies**: Only depend on what you need
6. **Const constructors**: Use const where possible
7. **Build optimization**: Minimize widget rebuilds

## Documentation Standards

### Code Comments
- Use `///` for public API documentation
- Use `//` for implementation notes
- Explain WHY, not WHAT (code should be self-explanatory)
- Update comments when code changes

**Example:**
```dart
/// Calculates the total price including discounts and taxes.
///
/// The discount is applied before tax calculation to ensure
/// customers get the best possible price.
///
/// Returns the final price rounded to 2 decimal places.
double calculateTotal(double price, double discount, double taxRate) {
  final discountedPrice = price * (1 - discount);
  final withTax = discountedPrice * (1 + taxRate);
  return double.parse(withTax.toStringAsFixed(2));
}
```

### Documentation Requirements
- **README updates mandatory**: Keep documentation in sync with code
- **API documentation**: Document all public APIs with dartdoc
- **Example usage**: Provide examples for complex features
- **Changelog updates**: Document all changes in CHANGELOG.md

## Git & Version Control

### Git Rules
- **Conventional commits**: Use conventional commit format
- **Small commits**: One logical change per commit
- **Branch naming**: feature/, bugfix/, hotfix/, docs/
- **PR requirements**: Tests passing, documentation updated, changelog updated
- **No secrets**: Never commit API keys, tokens, or credentials
- **Generated files**: Exclude `.g.dart`, `.freezed.dart` from version control

## Security Practices

- **No hardcoded secrets**: Use environment variables
- **Input validation**: Validate all user inputs
- **Secure storage**: Use secure storage for sensitive data
- **API security**: Implement proper authentication/authorization

## Routing Rules (go_router)

### Route Path Parameter Rules
Every route that requires an ID **MUST** have that ID as an explicit path parameter in its own path segment. Do NOT rely on inheriting parameters from parent routes.

```dart
// BAD: Relying on parent's :organizationId
GoRoute(
  path: ':organizationId',
  routes: [
    GoRoute(
      path: 'billing',  // Inherits organizationId from parent - NOT ALLOWED
      builder: (context, state) {
        final orgId = state.pathParameters['organizationId']!;
        return BillingPage(organizationId: orgId);
      },
    ),
  ],
)

// GOOD: Explicit path parameter in each route
GoRoute(
  path: ':organizationId',
  builder: (context, state) => OrganizationDetailPage(...),
),
GoRoute(
  path: ':organizationId/billing',
  builder: (context, state) {
    final orgId = state.pathParameters['organizationId']!;
    return BillingPage(organizationId: orgId);
  },
),
```

### No BlocProvider in Routes
**NEVER** wrap pages with BlocProvider in the router. BLoC providers belong in the page itself.

```dart
// BAD: BlocProvider in router
GoRoute(
  path: ':organizationId/billing',
  builder: (context, state) {
    final orgId = state.pathParameters['organizationId']!;
    return BlocProvider(  // NOT ALLOWED IN ROUTER
      create: (context) => BillingCubit(...),
      child: BillingPage(organizationId: orgId),
    );
  },
)

// GOOD: Page handles its own BLoC
GoRoute(
  path: ':organizationId/billing',
  builder: (context, state) {
    final orgId = state.pathParameters['organizationId']!;
    return BillingPage(organizationId: orgId);
  },
)

// In billing_page.dart:
class BillingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BillingCubit(
        billingRepository: context.read<BillingRepository>(),
        organizationId: organizationId,
      ),
      child: const _BillingPageContent(),
    );
  }
}
```

### Route Definition Rules
1. **Router file contains ONLY routing logic** - no UI components, no BlocProviders
2. **Each route with an ID must have explicit path param** - e.g., `:organizationId/billing` not nested `billing`
3. **Pages are responsible for their own state** - BLocProvider wrapping happens in the page
4. **Keep routes flat when possible** - avoid deep nesting that hides parameters

## Melos & Monorepo Rules

- Run `melos bootstrap` after dependency changes
- Use melos scripts for common tasks
- Keep package versions synchronized
- Test all packages before publishing

## Code Review Checklist

Before submitting code:
- [ ] Follows atomic design (small, focused components)
- [ ] One class per file (exceptions documented)
- [ ] Follows KISS principle (simple, readable)
- [ ] All resources properly disposed
- [ ] Null safety without `!` operators
- [ ] Error handling with user-friendly messages
- [ ] Immutable entities and states
- [ ] Tests written and passing
- [ ] No linter warnings
- [ ] Documentation updated
- [ ] No debug prints or commented code
- [ ] Follows clean architecture
- [ ] No relative imports used
- [ ] README reflects changes
- [ ] Changelog updated
- [ ] Performance impact considered
- [ ] Security implications reviewed
- [ ] Breaking changes documented
- [ ] Melos scripts still working

## Prohibited Practices

- Direct UI to Data layer communication
- Business logic in widgets
- Relative imports
- Ignoring errors
- Hardcoded secrets
- Massive refactors without approval
- Breaking changes without migration path
- Undocumented public APIs
- Functions returning widgets
- Skipping tests
- Using `!` operator without proof of non-null

## Enforcement

These rules are not suggestions - they are requirements for code quality and maintainability. All code must adhere to these standards.

**Priority Levels:**
- CRITICAL: Must fix immediately (security, crashes, data loss)
- HIGH: Must fix before merge (architecture violations, memory leaks)
- MEDIUM: Should fix soon (code quality, performance)
- LOW: Nice to have (minor refactoring, optimization)

## Questions?

When in doubt:
1. Check existing code for patterns
2. Refer to this document
3. Choose simplicity over complexity
4. Ask for clarification

**Remember**: Clean code is not about being clever - it's about being clear, consistent, and maintainable.
