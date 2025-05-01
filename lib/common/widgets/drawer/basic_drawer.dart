import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/data/models/auth/signout_user_req.dart';
import 'package:spotify_clone/domain/usecases/auth/signout.dart';
import 'package:spotify_clone/presentation/auth/pages/signin.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:spotify_clone/presentation/profile/bloc/profile_info_state.dart';
import 'package:spotify_clone/presentation/profile/pages/profile.dart';
import 'package:spotify_clone/service_locator.dart';

class BasicDrawer extends StatelessWidget {
  const BasicDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            sideMenuHeader(context),
            sideMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget sideMenuHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ProfilePage()));
      },
      child: Container(
        color: Colors.blueAccent,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            _profileInfo(context),
            SizedBox(
              height: 15,
            ),
            //Text(FirebaseAuth.instance.)
          ],
        ),
      ),
    );
  }

  Widget sideMenuItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: Icon(Icons.logout_rounded),
            title: Text('Sign Out'),
            onTap: () async {
              var result = await sl<SignoutUseCase>().call(
                  params: SignoutUserReq(
                email: FirebaseAuth.instance.currentUser?.email.toString(),
              ));
              result.fold((ifLeft) {
                var snackbar = SnackBar(content: Text(ifLeft));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }, (ifRight) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const SigninPage()),
                  (route) => false,
                );
              });
            },
          )
        ],
      ),
    );
  }

  Widget _profileInfo(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit()..getUser(),
      child: BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
        if (state is ProfileInfoLoading) {
          return Container(
              alignment: Alignment.center, child: CircularProgressIndicator());
        }
        if (state is ProfileInfoLoaded) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(state.userEntity.imageURL!))),
              ),
              SizedBox(
                height: 15,
              ),
              Text(state.userEntity.email!),
              SizedBox(
                height: 10,
              ),
              Text(
                state.userEntity.fullName!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          );
        }
        if (state is ProfileInfoFailure) {
          return Text('Please try again');
        }
        return Container();
      }),
    );
  }
}
