import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
	const LoginScreen({super.key});

	void _snack(BuildContext context, String msg) {
		ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
	}

	@override
	Widget build(BuildContext context) {
		return DefaultTabController(
			length: 2,
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
						const SizedBox(height: 8),
						// Handle + botón de cerrar
						Padding(
							padding: const EdgeInsets.symmetric(horizontal: 8.0),
							child: Stack(
								children: [
									// Handle centrado
									Align(
										alignment: Alignment.center,
										child: Container(
											width: 40,
											height: 4,
											decoration: BoxDecoration(
												color: Colors.black26,
												borderRadius: BorderRadius.circular(2),
											),
										),
									),
									// Cerrar arriba a la derecha
									Align(
										alignment: Alignment.centerRight,
										child: IconButton(
											tooltip: 'Cerrar',
											icon: const Icon(Icons.close),
											onPressed: () => Navigator.of(context).maybePop(),
										),
									),
								],
							),
						),
						const SizedBox(height: 8),
					Container(
						margin: const EdgeInsets.symmetric(horizontal: 16),
						decoration: BoxDecoration(
							color: Colors.grey.shade200,
							borderRadius: BorderRadius.circular(10),
						),
						child: const TabBar(
							indicator: BoxDecoration(
								color: Colors.white,
								borderRadius: BorderRadius.all(Radius.circular(10)),
							),
							labelColor: Colors.black,
							unselectedLabelColor: Colors.black54,
							tabs: [
								Tab(text: 'Iniciar sesión'),
								Tab(text: 'Registrarse'),
							],
						),
					),
					const SizedBox(height: 12),
					Flexible(
						child: TabBarView(
							children: [
								_LoginForm(onSubmit: () => _snack(context, 'funcion iniciar sesion')),
								_RegisterForm(onSubmit: () => _snack(context, 'funcion registrar')),
							],
						),
					),
					const SizedBox(height: 12),
				],
			),
		);
	}
}

class _LoginForm extends StatelessWidget {
	const _LoginForm({required this.onSubmit});
	final VoidCallback onSubmit;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.only(
				left: 16,
				right: 16,
				bottom: MediaQuery.of(context).viewInsets.bottom + 16,
			),
			child: ListView(
				shrinkWrap: true,
				children: [
					const Text('Correo electrónico'),
					const SizedBox(height: 6),
					const TextField(
						keyboardType: TextInputType.emailAddress,
						decoration: InputDecoration(
							border: OutlineInputBorder(),
							hintText: 'tucorreo@ejemplo.com',
						),
					),
					const SizedBox(height: 12),
					const Text('Contraseña'),
					const SizedBox(height: 6),
					const TextField(
						obscureText: true,
						decoration: InputDecoration(
							border: OutlineInputBorder(),
							hintText: '••••••••',
						),
					),
					const SizedBox(height: 16),
					SizedBox(
						width: double.infinity,
						child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSubmit();
              },
              child: const Text('Iniciar sesión'),
            ),
					),
				],
			),
		);
	}
}

class _RegisterForm extends StatelessWidget {
	const _RegisterForm({required this.onSubmit});
	final VoidCallback onSubmit;

	@override
	Widget build(BuildContext context) {
		return Padding(
			padding: EdgeInsets.only(
				left: 16,
				right: 16,
				bottom: MediaQuery.of(context).viewInsets.bottom + 16,
			),
			child: ListView(
				shrinkWrap: true,
				children: [
					const Text('Nombre'),
					const SizedBox(height: 6),
					const TextField(
						decoration: InputDecoration(
							border: OutlineInputBorder(),
							hintText: 'Tu nombre',
						),
					),
					const SizedBox(height: 12),
					const Text('Correo electrónico'),
					const SizedBox(height: 6),
					const TextField(
						keyboardType: TextInputType.emailAddress,
						decoration: InputDecoration(
							border: OutlineInputBorder(),
							hintText: 'tucorreo@ejemplo.com',
						),
					),
					const SizedBox(height: 12),
					const Text('Contraseña'),
					const SizedBox(height: 6),
					const TextField(
						obscureText: true,
						decoration: InputDecoration(
							border: OutlineInputBorder(),
							hintText: '••••••••',
						),
					),
					const SizedBox(height: 16),
					SizedBox(
						width: double.infinity,
						child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onSubmit();
              },
              child: const Text('Register'),
            ),
					),
				],
			),
		);
	}
}

