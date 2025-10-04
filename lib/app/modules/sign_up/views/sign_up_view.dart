import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:multi_admin/app/routes/app_pages.dart';

import '../../../styles/apps_colors.dart';
import '../../../styles/apps_style.dart';
import '../../../widgets/textfromfield.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/signupPage.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("Sign Up", style: AppStyles.authText),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "your journey star here Take the first step",
                    style: AppStyles.authText.copyWith(fontSize: 12),
                  ),
                ),
                SizedBox(height: height * 0.06),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradien,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "sudah punya akun?",
                                style: AppStyles.bodyTextWhite.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Get.offAndToNamed(Routes.SIGNIN),
                                child: Text(
                                  "Login",
                                  style: AppStyles.bodyTextWhite.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextFromFieldTemplate(
                            controller: controller.code_desa,
                            hintText: "Kode Desa",
                            keyboardType: TextInputType.text,
                            obscureText: false,
                          ),
                          TextFromFieldTemplate(
                            controller: controller.emailC,
                            hintText: "Email",
                            keyboardType: TextInputType.text,
                            obscureText: false,
                          ),
                          TextFromFieldTemplate(
                            controller: controller.katasandiC,
                            hintText: "Kata Sandi",
                            keyboardType: TextInputType.text,
                            obscureText: false,
                          ),
                          TextFromFieldTemplate(
                            controller: controller.konfir_katasandiC,
                            hintText: "Konfirmasi Kata Sandi",
                            keyboardType: TextInputType.text,
                            obscureText: false,
                          ),
                          SizedBox(height: height * 0.02),
                          Obx(
                            () => CheckboxListTile(
                              title: Text(
                                "Setuju dengan syarat & ketentuan",
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
                            onPressed: () => controller.signupAdmin(),
                            style: AppStyles.elevatedButtonStylePurpel.copyWith(
                              minimumSize: WidgetStateProperty.all(
                                Size(double.infinity, 20),
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                            ),
                            child: Text(
                              "daftar",
                              style: AppStyles.teksButtonKeania.copyWith(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
