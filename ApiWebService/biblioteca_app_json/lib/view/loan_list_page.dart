import 'package:biblioteca_app_json/controller/loan_controller.dart';
import 'package:flutter/material.dart';

class LoanListPage extends StatefulWidget {
  const LoanListPage({super.key});

  @override
  State<LoanListPage> createState() => _LoanListPageState();
}

class _LoanListPageState extends State<LoanListPage> {
  final _loanController = LoanController();
  int _refreshKey = 0;

  void _refresh() => setState(()=>_refreshKey++);

  String _formatDate (DateTime date) {
    return "${date.day.toString()}/${date.month.toString()}/${date.year.toString()}";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empréstimos')),
      body: FutureBuilder(
        key: ValueKey(_refreshKey),
        future: _loancontroller.fetchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final loans = snapshot.data as List<LoanModel>? ?? [];
          if (loans.isEmpty) {
            return const Center(child: Text('Nenhum empréstimo registrado'));
          }
          return ListView.builder(
            itemCount: loans.length,
            itemBuilder: (ctx, index) {
              final loan = loans[index];
              return ListTile(
                title: Text('Usuário: ${loan.user.name}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Livro: ${loan.book.title}'),
                    Text('De: ${_formatDate(loan.startDate)}'),
                    Text('Até: ${_formatDate(loan.dueDate)}'),
                    Text('Status: ${loan.returned ? "Devolvido" : "Ativo"}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoanFormPage(loan: loan),
                          ),
                        );
                        if (result == true) _refresh();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Excluir empréstimo'),
                            content: const Text('Deseja excluir este empréstimo?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _controller.delete(loan.id!);
                          _refresh();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoanFormPage()),
          );
          if (result == true) _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}