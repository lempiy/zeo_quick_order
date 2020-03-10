
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/fat32_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/models/fat32/fat32_api.dart';
import 'package:zeointranet/pages/fat32/quick_order.dart';

class Fat32 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionBloc = Provider.of<SessionBloc>(context);
    return BlocProvider<Fat32Bloc>(
      builder: (_, bloc) => bloc ?? Fat32Bloc(Fat32Api(), sessionBloc),
      onDispose: (_, bloc) => bloc.dispose(),
      child: SafeArea(
        child: QuickOrder(),
      ),
    );
  }
}
