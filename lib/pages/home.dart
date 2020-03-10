import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zeointranet/bloc/fat32_bloc.dart';
import 'package:zeointranet/bloc/session_bloc.dart';
import 'package:zeointranet/bloc/provider.dart';
import 'package:zeointranet/models/fat32/fat32_api.dart';
import 'package:zeointranet/pages/_logged_in_only.dart';
import 'package:zeointranet/pages/app_bar.dart';
import 'package:zeointranet/pages/bottom_bar.dart';
import 'package:zeointranet/pages/fat32/index.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sessionBloc = Provider.of<SessionBloc>(context);
    return LoggedInOnly(
      child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          key: ValueKey("homePage"),
          appBar: getAppBar(sessionBloc),
          body: Fat32(),
//          bottomNavigationBar: getBottomBar(context),
        ),
    );
  }
}
