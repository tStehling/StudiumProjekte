import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart'
    show OfflineFirstWithSupabaseModel;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:revier_app_client/common/widgets/buttons/extended_floating_action_button.dart';
import 'model_handler.dart';
import 'package:revier_app_client/localization/app_localizations.dart';

/// A generic list view for displaying entities.
///
/// This widget displays a list of entities and allows navigating to detail/edit views.
class EntityListView<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerStatefulWidget {
  /// The handler for the model type.
  final ModelHandler<T> modelHandler;

  /// Callback when an entity is tapped.
  final void Function(T entity) onEntityTap;

  /// Callback when the add button is tapped.
  final void Function()? onAddTap;

  /// Whether to show the add button.
  final bool showAddButton;

  /// Additional actions to display in the app bar.
  final List<Widget>? actions;

  /// The list view layout type.
  final ListViewType listViewType;

  const EntityListView({
    super.key,
    required this.modelHandler,
    required this.onEntityTap,
    this.onAddTap,
    this.showAddButton = true,
    this.actions,
    this.listViewType = ListViewType.list,
  });

  @override
  ConsumerState<EntityListView<T>> createState() => _EntityListViewState<T>();
}

/// The layout type for the entity list.
enum ListViewType {
  list,
  grid,
}

class _EntityListViewState<T extends OfflineFirstWithSupabaseModel>
    extends ConsumerState<EntityListView<T>> {
  bool _isLoading = false;
  List<T> _entities = [];
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final entities = await widget.modelHandler.fetchAll(ref);
      setState(() {
        _entities = entities;
      });
    } catch (e) {
      // TODO: Handle error
      debugPrint('Error loading entities: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<T> get _filteredEntities {
    if (_searchQuery.isEmpty) {
      return _entities;
    }

    final query = _searchQuery.toLowerCase();
    return _entities.where((entity) {
      for (final field in widget.modelHandler.searchableFields) {
        final value = widget.modelHandler.getFieldValue(entity, field);
        if (value != null &&
            widget.modelHandler
                .formatDisplayValue(field, value)
                .toLowerCase()
                .contains(query)) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _filteredEntities.length,
      itemBuilder: (context, index) {
        final entity = _filteredEntities[index];
        return ListTile(
          title: Text(widget.modelHandler.getDisplayText(entity)),
          onTap: () => widget.onEntityTap(entity),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _filteredEntities.length,
      itemBuilder: (context, index) {
        final entity = _filteredEntities[index];
        return Card(
          elevation: 2,
          child: InkWell(
            onTap: () => widget.onEntityTap(entity),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  widget.modelHandler.getDisplayText(entity),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.modelHandler.modelTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _EntitySearchDelegate<T>(
                  widget.modelHandler,
                  _entities,
                  widget.onEntityTap,
                ),
              );
            },
          ),
          if (widget.actions != null) ...widget.actions!,
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredEntities.isEmpty
              ? Center(
                  child: Text(
                      'No ${widget.modelHandler.modelTitle.toLowerCase()} found'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.listViewType == ListViewType.list
                      ? _buildListView()
                      : _buildGridView(),
                ),
      floatingActionButton: widget.showAddButton && widget.onAddTap != null
          ? ExtendedFloatingActionButton(
              type: ButtonType.add,
              tooltip: 'Add ${widget.modelHandler.modelTitle}',
              onPressed: widget.onAddTap,
              isFlyoutMode: false,
            )
          : null,
    );
  }
}

class _EntitySearchDelegate<T extends OfflineFirstWithSupabaseModel>
    extends SearchDelegate<T?> {
  final ModelHandler<T> modelHandler;
  final List<T> entities;
  final void Function(T) onEntityTap;

  _EntitySearchDelegate(this.modelHandler, this.entities, this.onEntityTap);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (query.isEmpty) {
      return const Center(child: Text('Type to search'));
    }

    final filteredEntities = entities.where((entity) {
      for (final field in modelHandler.searchableFields) {
        final value = modelHandler.getFieldValue(entity, field);
        if (value != null &&
            modelHandler
                .formatDisplayValue(field, value)
                .toLowerCase()
                .contains(query.toLowerCase())) {
          return true;
        }
      }
      return false;
    }).toList();

    if (filteredEntities.isEmpty) {
      return Center(child: Text('${l10n.noResultFor} "$query"'));
    }

    return ListView.builder(
      itemCount: filteredEntities.length,
      itemBuilder: (context, index) {
        final entity = filteredEntities[index];
        return ListTile(
          title: Text(modelHandler.getDisplayText(entity)),
          onTap: () {
            onEntityTap(entity);
            close(context, entity);
          },
        );
      },
    );
  }
}
