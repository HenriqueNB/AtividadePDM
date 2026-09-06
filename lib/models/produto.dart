// lib/models/produto.dart
//
// Modelo de dados que representa um Produto vindo de uma API JSON.
// Aplica: tipagem estrita, imutabilidade (final), null safety (required)
// e uma regra de negócio (getter temEstoqueCritico).

class Produto {
  final String nomeProduto;
  final String categoria;
  final double preco;
  final int quantidadeEstoque;
  final bool disponivel;
  final List<String> tags;

  // Construtor com parâmetros nomeados obrigatórios.
  // Como os campos são `final`, uma vez criado o objeto ele não muda mais
  // (imutabilidade) — cada novo produto exige um novo objeto Produto.
  Produto({
    required this.nomeProduto,
    required this.categoria,
    required this.preco,
    required this.quantidadeEstoque,
    required this.disponivel,
    required this.tags,
  });

  // Regra de negócio encapsulada dentro do próprio modelo:
  // o "dono" da informação de estoque é a classe Produto, não a tela.
  bool get temEstoqueCritico => quantidadeEstoque < 5;

  // Factory constructor: converte um Map (vindo do JSON decodificado)
  // em um objeto Produto, fazendo conversão segura dos tipos numéricos.
  //
  // Por que "conversão segura"? Porque o JSON pode trazer um número
  // inteiro (12) onde esperamos double (12.0), ou vice-versa. Usar
  // `.toDouble()` e `.toInt()` evita erros de tipo em tempo de execução.
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      nomeProduto: json['nome_produto'] as String,
      categoria: json['categoria'] as String,
      preco: (json['preco'] as num).toDouble(),
      quantidadeEstoque: (json['quantidade_estoque'] as num).toInt(),
      disponivel: json['disponivel'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }
}