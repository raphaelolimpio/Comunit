import 'package:dicionario/Service/favorite_service.dart';
import 'package:flutter/material.dart';

class FavoriteToggleButton extends StatefulWidget {
  final int itemId;
  final String tipo; // Ex: 'termo' ou 'snippet'
  final bool initialIsFavorited;
  final VoidCallback? onFavoriteChanged;

  const FavoriteToggleButton({
    Key? key,
    required this.itemId,
    required this.tipo,
    this.initialIsFavorited = false,
    this.onFavoriteChanged,
  }) : super(key: key);

  @override
  State<FavoriteToggleButton> createState() => _FavoriteToggleButtonState();
}

class _FavoriteToggleButtonState extends State<FavoriteToggleButton> {
  late bool _isFavorited;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.initialIsFavorited;
  }

  Future<void> _handleToggle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _isFavorited = !_isFavorited; // Feedback visual imediato (otimista)
    });

    try {
      // Chama o método estático real do seu FavoriteService
      final success = await FavoriteService.toggleFavorito(
        tipo: widget.tipo,
        itemId: widget.itemId,
      );

      if (!success) {
        // Se falhou na API, reverte o estado visual
        setState(() {
          _isFavorited = !_isFavorited;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao atualizar favorito.')),
          );
        }
      } else {
        widget.onFavoriteChanged?.call();
      }
    } catch (e) {
      setState(() {
        _isFavorited = !_isFavorited;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorited ? Icons.favorite : Icons.favorite_border,
        color: _isFavorited ? Colors.red : Colors.grey,
        size: 22,
      ),
      onPressed: _isLoading ? null : _handleToggle,
      tooltip: _isFavorited ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
    );
  }
}