import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentapp/theme/theme.dart';
// Add in pubspec.yaml to enable inline video playback:
// dependencies:
//   video_player: ^2.9.2
import 'package:video_player/video_player.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final List<Post> _posts = [];
  bool _isLoading = false;
  // ignore: unused_field
  bool _isRefreshing = false;
  bool _hasMore = true;
  int _page = 0;
  static const int _pageSize = 45;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitial() async {
    setState(() => _isLoading = true);
    final newPosts = await _MockFeedRepository.loadPage(
      page: 0,
      pageSize: _pageSize,
    );
    setState(() {
      _posts
        ..clear()
        ..addAll(newPosts);
      _isLoading = false;
      _hasMore = newPosts.length == _pageSize;
      _page = 1;
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);
    final newPosts = await _MockFeedRepository.loadPage(
      page: _page,
      pageSize: _pageSize,
      query: _searchController.text,
    );
    setState(() {
      _posts.addAll(newPosts);
      _isLoading = false;
      _hasMore = newPosts.length == _pageSize;
      _page += 1;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 600) {
      _loadMore();
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await _loadInitial();
    setState(() => _isRefreshing = false);
  }

  void _openViewer(int index) {
    if (index < 0 || index >= _posts.length) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaViewerPage(
          posts: _posts,
          initialIndex: index,
          onChanged: (updated) {
            // Trigger a rebuild when an item updates (likes/bookmarks/comments)
            setState(() {});
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildSearchBar() {
    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) {
            _page = 0;
            _loadInitial();
          },
          decoration: InputDecoration(
            hintText: 'Search homes, locations, tags...',
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _page = 0;
                      _loadInitial();
                    },
                  ),
          ),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Filters',
          onPressed: () => _showQuickFilters(),
          icon: const Icon(Icons.tune),
        ),
      ],
    );
  }

  void _showQuickFilters() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        RangeValues price = const RangeValues(500, 2500);
        bool videosOnly = false;
        bool imagesOnly = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Quick filters',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilterChip(
                        label: const Text('Images'),
                        selected: imagesOnly,
                        onSelected: (v) => setModalState(() {
                          imagesOnly = v;
                          if (v) videosOnly = false;
                        }),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Videos'),
                        selected: videosOnly,
                        onSelected: (v) => setModalState(() {
                          videosOnly = v;
                          if (v) imagesOnly = false;
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Price'),
                      Expanded(
                        child: RangeSlider(
                          min: 0,
                          max: 5000,
                          divisions: 100,
                          values: price,
                          onChanged: (v) => setModalState(() => price = v),
                        ),
                      ),
                      Text('\$${price.start.round()} - \$${price.end.round()}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: igBlue, // igblue color
                      ),
                      onPressed: () {
                        // For demo, we just refetch with current query.
                        Navigator.pop(ctx);
                        _page = 0;
                        _loadInitial();
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                  SafeArea(child: SizedBox(height: 8)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGrid() {
    if (_isLoading && _posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(2),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final post = _posts[index];
                return _MediaTile(
                  post: post,
                  onOpen: () => _openViewer(index),
                  onToggleLike: () {
                    setState(() {
                      post.liked = !post.liked;
                      post.likeCount += post.liked ? 1 : -1;
                    });
                  },
                );
              }, childCount: _posts.length),
            ),
          ),
          SliverToBoxAdapter(
            child: _hasMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildSearchBar(), body: _buildGrid());
  }
}

class _MediaTile extends StatefulWidget {
  final Post post;
  final VoidCallback onOpen;
  final VoidCallback onToggleLike;

  const _MediaTile({
    required this.post,
    required this.onOpen,
    required this.onToggleLike,
  });

  @override
  State<_MediaTile> createState() => _MediaTileState();
}

class _MediaTileState extends State<_MediaTile>
    with SingleTickerProviderStateMixin {
  bool _showHeart = false;

  Future<void> _handleDoubleTapLike() async {
    if (!widget.post.liked) {
      widget.onToggleLike();
    }
    setState(() => _showHeart = true);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) setState(() => _showHeart = false);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return GestureDetector(
      onTap: widget.onOpen,
      onDoubleTap: _handleDoubleTapLike,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'post-${post.id}',
            child: post.isVideo
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        post.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorBuilder: _errorBuilder,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_circle_filled_rounded,
                          size: 46,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  )
                : Image.network(
                    post.mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: _errorBuilder,
                  ),
          ),
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${post.likeCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chat_bubble, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${post.commentCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    widget.post.rating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _showHeart ? 1 : 0,
            child: Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 350),
                scale: _showHeart ? 1 : 0.8,
                curve: Curves.easeOutBack,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: Colors.grey.shade300,
      alignment: Alignment.center,
      child: const Icon(Icons.image_not_supported_outlined),
    );
  }
}

class MediaViewerPage extends StatefulWidget {
  final List<Post> posts;
  final int initialIndex;
  final ValueChanged<Post>? onChanged;

  const MediaViewerPage({
    super.key,
    required this.posts,
    required this.initialIndex,
    this.onChanged,
  });

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final PageController _pageController;
  int _index = 0;
  bool _uiVisible = true;

  Post get post => widget.posts[_index];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _pageController = PageController(initialPage: _index);
  }

  void _toggleLike() {
    setState(() {
      post.liked = !post.liked;
      post.likeCount += post.liked ? 1 : -1;
    });
    widget.onChanged?.call(post);
  }

  void _toggleBookmark() {
    setState(() => post.bookmarked = !post.bookmarked);
    widget.onChanged?.call(post);
  }

  void _openComments() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => CommentsAndReviewsSheet(
        post: post,
        onUpdated: (p) {
          setState(() {});
          widget.onChanged?.call(p);
        },
      ),
    );
  }

  void _share() async {
    await Clipboard.setData(
      ClipboardData(text: 'https://rentapp.example/post/${post.id}'),
    );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Post link copied')));
    }
  }

  Future<void> _handleDoubleTap() async {
    if (!post.liked) _toggleLike();
    // Feedback animation is handled inside the content widget (LikeOverlay)
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _index = i),
            itemCount: widget.posts.length,
            itemBuilder: (context, i) {
              final p = widget.posts[i];
              return _ViewerItem(
                key: ValueKey('viewer-${p.id}'),
                post: p,
                onToggleUi: () => setState(() => _uiVisible = !_uiVisible),
                onDoubleTapLike: _handleDoubleTap,
              );
            },
          ),
          if (_uiVisible) ...[
            SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _share,
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black87, Colors.transparent],
                      stops: [0, 1],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: _toggleLike,
                            icon: Icon(
                              post.liked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: post.liked
                                  ? Colors.redAccent
                                  : Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: _openComments,
                            icon: const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: _share,
                            icon: const Icon(
                              Icons.send_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _toggleBookmark,
                            icon: Icon(
                              post.bookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: post.bookmarked
                                  ? colorScheme.primary
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              '${post.likeCount} likes',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${post.commentCount} comments',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  post.rating.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (post.caption.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 8),
                          child: Text(
                            post.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ViewerItem extends StatefulWidget {
  final Post post;
  final VoidCallback onToggleUi;
  final Future<void> Function() onDoubleTapLike;

  const _ViewerItem({
    super.key,
    required this.post,
    required this.onToggleUi,
    required this.onDoubleTapLike,
  });

  @override
  State<_ViewerItem> createState() => _ViewerItemState();
}

class _ViewerItemState extends State<_ViewerItem> {
  bool _showHeart = false;

  Future<void> _pulseHeart() async {
    setState(() => _showHeart = true);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) setState(() => _showHeart = false);
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onToggleUi,
      onDoubleTap: () async {
        await widget.onDoubleTapLike();
        await _pulseHeart();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'post-${post.id}',
            child: post.isVideo
                ? _VideoPlayerView(
                    url: post.mediaUrl,
                    thumbnail: post.thumbnailUrl,
                  )
                : InteractiveViewer(
                    child: Image.network(
                      post.mediaUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: _showHeart ? 1 : 0,
            child: Center(
              child: AnimatedScale(
                duration: const Duration(milliseconds: 350),
                scale: _showHeart ? 1 : 0.8,
                curve: Curves.easeOutBack,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 120,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayerView extends StatefulWidget {
  final String url;
  final String thumbnail;

  const _VideoPlayerView({required this.url, required this.thumbnail});

  @override
  State<_VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<_VideoPlayerView> {
  VideoPlayerController? _controller;
  bool _muted = true;
  // ignore: unused_field
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(_muted ? 0 : 1);
    await controller.play();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    final c = _controller;
    if (c == null) return;
    setState(() => _showControls = true);
    if (c.value.isPlaying) {
      await c.pause();
    } else {
      await c.play();
    }
    setState(() {});
    // Hide controls after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleMute() {
    final c = _controller;
    if (c == null) return;
    setState(() {
      _muted = !_muted;
      c.setVolume(_muted ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            widget.thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => const SizedBox.shrink(),
          ),
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: c.value.size.width,
            height: c.value.size.height,
            child: VideoPlayer(c),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 24,
          child: Column(
            children: [
              _IconCircleButton(
                icon: _muted ? Icons.volume_off : Icons.volume_up,
                onTap: _toggleMute,
              ),
              const SizedBox(height: 8),
              _IconCircleButton(
                icon: c.value.isPlaying ? Icons.pause : Icons.play_arrow,
                onTap: _togglePlay,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class CommentsAndReviewsSheet extends StatefulWidget {
  final Post post;
  final ValueChanged<Post> onUpdated;

  const CommentsAndReviewsSheet({
    super.key,
    required this.post,
    required this.onUpdated,
  });

  @override
  State<CommentsAndReviewsSheet> createState() =>
      _CommentsAndReviewsSheetState();
}

class _CommentsAndReviewsSheetState extends State<CommentsAndReviewsSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _commentController = TextEditingController();
  int _reviewStars = 5;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.post.comments.insert(
        0,
        Comment(author: 'You', text: text, createdAt: DateTime.now()),
      );
      widget.post.commentCount = widget.post.comments.length;
      _commentController.clear();
    });
    widget.onUpdated(widget.post);
  }

  void _addReview() {
    final text = _reviewController.text.trim();
    if (_reviewStars <= 0) return;
    setState(() {
      widget.post.reviews.insert(
        0,
        Review(
          author: 'You',
          rating: _reviewStars,
          text: text,
          createdAt: DateTime.now(),
        ),
      );
      widget.post.rating = _computeAvg(widget.post.reviews);
      _reviewController.clear();
      _reviewStars = 5;
    });
    widget.onUpdated(widget.post);
  }

  double _computeAvg(List<Review> reviews) {
    if (reviews.isEmpty) return 0;
    final sum = reviews.fold<int>(0, (a, b) => a + b.rating);
    return sum / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, controller) {
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Comments'),
                  Tab(text: 'Reviews'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Comments
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: widget.post.comments.length,
                            itemBuilder: (_, i) {
                              final c = widget.post.comments[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    c.author.isNotEmpty ? c.author[0] : '?',
                                  ),
                                ),
                                title: Text(
                                  c.author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(c.text),
                                trailing: Text(
                                  _prettyTime(c.createdAt),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment...',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: _addComment,
                                icon: const Icon(Icons.send),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Reviews
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: controller,
                            itemCount: widget.post.reviews.length,
                            itemBuilder: (_, i) {
                              final r = widget.post.reviews[i];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(
                                    r.author.isNotEmpty ? r.author[0] : '?',
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Text(
                                      r.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _Stars(rating: r.rating),
                                  ],
                                ),
                                subtitle: Text(
                                  r.text.isEmpty ? '(no comment)' : r.text,
                                ),
                                trailing: Text(
                                  _prettyTime(r.createdAt),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Your rating'),
                              Row(
                                children: List.generate(5, (i) {
                                  final idx = i + 1;
                                  return IconButton(
                                    onPressed: () =>
                                        setState(() => _reviewStars = idx),
                                    icon: Icon(
                                      idx <= _reviewStars
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color: Colors.amber,
                                    ),
                                  );
                                }),
                              ),
                              TextField(
                                controller: _reviewController,
                                decoration: const InputDecoration(
                                  hintText: 'Write a short review (optional)',
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: _addReview,
                                  child: const Text('Submit review'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final num rating;

  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final idx = i + 1;
        return Icon(
          idx <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
          color: Colors.amber,
          size: 18,
        );
      }),
    );
  }
}

String _prettyTime(DateTime date) {
  final d = DateTime.now().difference(date);
  if (d.inMinutes < 1) return 'now';
  if (d.inMinutes < 60) return '${d.inMinutes}m';
  if (d.inHours < 24) return '${d.inHours}h';
  return '${d.inDays}d';
}

// Data models and mock repo

class Post {
  final String id;
  final bool isVideo;
  final String mediaUrl;
  final String thumbnailUrl;
  final String caption;
  int likeCount;
  int commentCount;
  bool liked;
  bool bookmarked;
  double rating;
  final List<Comment> comments;
  final List<Review> reviews;

  Post({
    required this.id,
    required this.isVideo,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.caption,
    required this.likeCount,
    required this.commentCount,
    required this.liked,
    required this.bookmarked,
    required this.rating,
    required this.comments,
    required this.reviews,
  });
}

class Comment {
  final String author;
  final String text;
  final DateTime createdAt;

  Comment({required this.author, required this.text, required this.createdAt});
}

class Review {
  final String author;
  final int rating; // 1-5
  final String text;
  final DateTime createdAt;

  Review({
    required this.author,
    required this.rating,
    required this.text,
    required this.createdAt,
  });
}

class _MockFeedRepository {
  static final Random _rnd = Random();

  static Future<List<Post>> loadPage({
    required int page,
    required int pageSize,
    String? query,
  }) async {
    await Future.delayed(Duration(milliseconds: 400 + _rnd.nextInt(400)));
    final base = page * pageSize;
    return List.generate(pageSize, (i) {
      final id = (base + i + 1).toString();
      final isVideo = _rnd.nextDouble() < 0.25; // 25% videos
      final imageId = 100 + base + i;
      final imgUrl = 'https://picsum.photos/id/$imageId/600/600';
      // Safe short sample videos with preview thumbnail
      final videoUrl = _pickSampleVideo();
      final thumbnail = 'https://picsum.photos/id/${imageId + 1}/800/800';
      final likes = 10 + _rnd.nextInt(4500);
      final comments = 1 + _rnd.nextInt(250);
      final reviews = _seedReviews();
      final rating = reviews.isEmpty
          ? 0
          : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
                reviews.length;
      return Post(
        id: id,
        isVideo: isVideo,
        mediaUrl: isVideo ? videoUrl : imgUrl,
        thumbnailUrl: isVideo ? thumbnail : imgUrl,
        caption: _sampleCaption(),
        likeCount: likes,
        commentCount: comments,
        liked: _rnd.nextBool() && _rnd.nextBool(),
        bookmarked: _rnd.nextBool() && _rnd.nextBool(),
        rating: rating.toDouble(),
        comments: _seedComments(),
        reviews: reviews,
      );
    });
  }

  static String _pickSampleVideo() {
    // Short public domain/sample clips
    const samples = [
      'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
      'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
      'https://samplelib.com/lib/preview/mp4/sample-15s.mp4',
    ];
    return samples[_rnd.nextInt(samples.length)];
  }

  static List<Comment> _seedComments() {
    final n = _rnd.nextInt(6);
    return List.generate(n, (i) {
      return Comment(
        author: _names[_rnd.nextInt(_names.length)],
        text: _comments[_rnd.nextInt(_comments.length)],
        createdAt: DateTime.now().subtract(
          Duration(minutes: _rnd.nextInt(6000)),
        ),
      );
    });
  }

  static List<Review> _seedReviews() {
    final n = _rnd.nextInt(5);
    return List.generate(n, (i) {
      return Review(
        author: _names[_rnd.nextInt(_names.length)],
        rating: 3 + _rnd.nextInt(3), // 3-5
        text: _reviews[_rnd.nextInt(_reviews.length)],
        createdAt: DateTime.now().subtract(Duration(days: _rnd.nextInt(120))),
      );
    });
  }

  static String _sampleCaption() {
    const caps = [
      'Sunny 2BR downtown, close to transit.',
      'Cozy studio with city view.',
      'Modern loft with open kitchen.',
      'Spacious family home near park.',
      'Renovated apartment with balcony.',
      'Quiet neighborhood, pet-friendly.',
      'Near university district, great for students.',
    ];
    return caps[_rnd.nextInt(caps.length)];
  }

  static const _names = [
    'Alex',
    'Sam',
    'Jordan',
    'Taylor',
    'Morgan',
    'Riley',
    'Avery',
    'Casey',
  ];

  static const _comments = [
    'Looks amazing!',
    'What’s the monthly rent?',
    'Is parking included?',
    'Pet friendly?',
    'Available next month?',
    'Love the kitchen!',
  ];

  static const _reviews = [
    'Great location and responsive landlord.',
    'Clean and quiet, would recommend.',
    'Good value for the price.',
    'Some noise at night, but overall fine.',
    'Amazing amenities nearby.',
  ];
}
