import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.hub,
                    color: AppColors.onEmerald, size: 42),
              ),
              const SizedBox(height: 20),
              const Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: 'ALU Intercampus\n',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  TextSpan(
                      text: 'Connect',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.emerald)),
                ]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text('Connect. Collaborate. Lead together.',
                  style: TextStyle(color: AppColors.textSecondary)),
              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: state.login,
                  icon: const Icon(Icons.account_circle, size: 20),
                  label: const Text('Sign in with ALU Account',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: const [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or continue with',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _social(Icons.g_mobiledata, 'Google', state.login),
                  const SizedBox(width: 18),
                  _social(Icons.apple, 'Apple', state.login),
                ],
              ),
              const Spacer(flex: 2),
              GestureDetector(
                onTap: state.login,
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: 'New here? ',
                        style: TextStyle(color: AppColors.textSecondary)),
                    TextSpan(
                        text: 'Create account',
                        style: TextStyle(
                            color: AppColors.emerald,
                            fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _social(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 34),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
