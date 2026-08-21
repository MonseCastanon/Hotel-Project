import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hotel_app/domain/entities/user.dart';
import 'package:hotel_app/presentation/providers/admin/employees_provider.dart';

class EmployeeDetailScreen extends ConsumerStatefulWidget {
  final User employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  ConsumerState<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends ConsumerState<EmployeeDetailScreen> {
  UserRole? _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.employee.role == UserRole.unassigned ? null : widget.employee.role;
  }

  Future<void> _updateEmployee(UserStatus newStatus) async {
    if (newStatus == UserStatus.active && _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar un rol para activar al usuario.')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar acción'),
        content: Text(
          'Usuario: ${widget.employee.name}\n'
          'Nuevo Rol: ${newStatus == UserStatus.active ? _selectedRole?.label : widget.employee.role.label}\n'
          'Nuevo Estado: ${newStatus.label}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar')),
        ],
      ),
    );

    if (confirm == true) {
      final roleToSet = newStatus == UserStatus.active ? _selectedRole! : widget.employee.role;
      await ref.read(employeesProvider.notifier).updateEmployeeRoleAndStatus(
        widget.employee.id,
        roleToSet,
        newStatus,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado actualizado correctamente.'), backgroundColor: Colors.green),
        );
        context.pop(); // Volver a la lista
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(employeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Empleado'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Información General', style: Theme.of(context).textTheme.titleLarge),
                        const Divider(),
                        _buildInfoRow('Nombre', widget.employee.name),
                        _buildInfoRow('Correo', widget.employee.email),
                        _buildInfoRow('Fecha Registro', widget.employee.createdAt.toLocal().toString().split('.')[0]),
                        _buildInfoRow('Estado Actual', widget.employee.status.label),
                        _buildInfoRow('Rol Actual', widget.employee.role.label),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Selector de rol
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Asignar Rol', style: Theme.of(context).textTheme.titleLarge),
                        const Divider(),
                        DropdownButtonFormField<UserRole>(
                          value: _selectedRole,
                          hint: const Text('Selecciona un rol'),
                          items: UserRole.values
                              .where((r) => r != UserRole.unassigned)
                              .map((r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r.label),
                                  ))
                              .toList(),
                          onChanged: (role) {
                            setState(() {
                              _selectedRole = role;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.employee.status != UserStatus.rejected)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.close, color: Colors.red),
                        label: const Text('Rechazar', style: TextStyle(color: Colors.red)),
                        onPressed: () => _updateEmployee(UserStatus.rejected),
                      ),
                    
                    if (widget.employee.status == UserStatus.active)
                      OutlinedButton.icon(
                        icon: const Icon(Icons.block, color: Colors.grey),
                        label: const Text('Desactivar', style: TextStyle(color: Colors.grey)),
                        onPressed: () => _updateEmployee(UserStatus.inactive),
                      ),
                      
                    if (widget.employee.status != UserStatus.active)
                      FilledButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('Aprobar / Activar'),
                        onPressed: () => _updateEmployee(UserStatus.active),
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
