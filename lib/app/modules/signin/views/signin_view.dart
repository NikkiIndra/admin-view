import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../styles/apps_colors.dart';
import '../../../styles/apps_style.dart';
import '../../../widgets/textfromfield.dart';
import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/images/signinPage.png"),
              //   fit: BoxFit.cover,
              // ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("Sign In", style: AppStyles.authText),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "your journey star here Take the first step",
                  style: AppStyles.authText.copyWith(fontSize: 12),
                ),
              ),
              SizedBox(height: height * 0.3),
              Container(
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradien,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "sudah belum punya akun?",
                            style: AppStyles.bodyTextWhite,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.SINGUP);
                            },
                            child: Text(
                              "Daftar",
                              style: AppStyles.bodyTextWhite,
                            ),
                          ),
                        ],
                      ),
                      TextFromFieldTemplate(
                        controller: controller.emailC,
                        hintText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      Obx(
                        () => TextFromFieldTemplate(
                          controller: controller.katasandiC,
                          hintText: "Kata Sandi",
                          isPassword: true,
                          isPasswordHidden: controller.isPasswordHidden.value,
                          onToggle: controller.isPasswordHidden.toggle,
                        ),
                      ),
                      SizedBox(height: height * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Lupa Kata Sandi?",
                                style: AppStyles.bodyTextWhite.copyWith(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets
                                      .zero, // biar ga ada spasi default
                                  minimumSize: Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Klik Disini",
                                  style: AppStyles.bodyTextWhite.copyWith(
                                    fontSize: 12,
                                    color: AppColors.white35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Obx(
                        () => CheckboxListTile(
                          title: Text(
                            "ingatkan aku",
                            style: AppStyles.bodyTextWhite.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          dense: true,

                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColors.white35,
                          checkColor: Colors.white,
                          side: BorderSide(color: Colors.white70),
                          value: controller.isChecked.value,
                          onChanged: (val) {
                            controller.isChecked.value = val ?? false;
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => controller.login(),
                        style: AppStyles.elevatedButtonStylePurpel.copyWith(
                          minimumSize: WidgetStateProperty.all(
                            Size(double.infinity, 20),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: Text(
                          "Masuk Sekarang",
                          style: AppStyles.teksButtonKeania.copyWith(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
