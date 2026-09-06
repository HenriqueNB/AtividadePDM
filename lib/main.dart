// lib/main.dart
//
// Tela principal do app: consome o modelo Produto e exibe as
// informações em um Card com Material Design 3.

import 'package:flutter/material.dart';
import 'models/produto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo Mobile',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const TelaCatalogo(),
    );
  }
}

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key});

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  // Simula o JSON que viria de uma API.
  // Em um app real, isso normalmente viria de um http.get(...) e depois
  // seria passado para Produto.fromJson(jsonDecode(response.body)).
  final Map<String, dynamic> _jsonSimulado = const {
    "nome_produto": "Smartphone Galaxy S24",
    "categoria": "Mobile",
    "preco": 4599.90,
    "quantidade_estoque": 12,
    "disponivel": true,
    "tags": ["android", "5g", "snapdragon"],
  };

  late Produto _produto;

  @override
  void initState() {
    super.initState();
    _produto = Produto.fromJson(_jsonSimulado);
  }

  // Simula um "recarregar dados da API" ao apertar o ícone da AppBar.
  // Aqui só reconstruímos o mesmo produto, mas em um cenário real
  // seria uma nova chamada de rede.
  void _recarregarDados() {
    setState(() {
      _produto = Produto.fromJson(_jsonSimulado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: _recarregarDados,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _produto.nomeProduto,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  _produto.categoria,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'R\$ ${_produto.preco.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),

                // Tags exibidas como Chips.
                Wrap(
                  spacing: 8,
                  children: _produto.tags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),
                const SizedBox(height: 16),

                // Feedback visual dinâmico: só aparece se o estoque
                // estiver crítico (regra vinda do próprio modelo).
                if (_produto.temEstoqueCritico)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.red[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Estoque crítico: apenas ${_produto.quantidadeEstoque} unidades',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'Em estoque: ${_produto.quantidadeEstoque} unidades',
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _recarregarDados,
        child: const Icon(Icons.sync),
      ),
    );
  }
}