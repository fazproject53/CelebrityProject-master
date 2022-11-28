import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:http/http.dart' as http;

class GenerateContract {
  static DateTime date = DateTime.now();
  //generateContract=============================================================
  static Future<Uint8List> generateContract({
    required String celerityName,
    required String celerityIdNumber,
    required String celerityNationality,
    required String celerityVerifiedType,
    required String celerityVerifiedNumber,
    required String celerityCityName,
    required String celerityPhone,
    required String celerityEmail,
    required String userName,
    required String userIdNumber,
    required String userNationality,
    required String userVerifiedType,
    required String userVerifiedNumber,
    required String userCityName,
    required String userPhone,
    required String userEmail,
    required String platform,
    required String advDescription,
    required String advLink,
    required String advTime,
    required String advProductOrService,
    required String advOrAdvSpace,
    required String advDate,
    required String? celeritySigntion,
    required String? userSingture,
    String? sendDate,
    PdfPageFormat? format,
  }) async {
    print("userSingture: $userSingture");
    print("celeritySigntion: $celeritySigntion");
    String userType = userNationality == 'سعودي' ? 'إقامة' : 'هوية';
    String celpType = celerityNationality == 'سعودي' ? 'إقامة' : 'هوية';
    String sendDate2 = sendDate!;
    var arabicFont = Font.ttf(
        await rootBundle.load("assets/font/DINNextLTArabic-Regular-2.ttf"));
    var imageImage = MemoryImage(
        (await rootBundle.load('assets/image/hedar.png')).buffer.asUint8List());

    var responseUser, responseCelp;
    var dataUser, dataCelp;
    //
    if (userSingture != null && userSingture != "") {
      responseUser = await http.get(Uri.parse(userSingture));

      dataUser = responseUser.bodyBytes;
    }

    if (celeritySigntion != null && celeritySigntion != "") {
      responseCelp = await http.get(Uri.parse(celeritySigntion));
      dataCelp = responseCelp.bodyBytes;
    }
    //------------------------

//========================================================
    String pragraf1 = 'انه في يوم' +
        ' ' +
        '$sendDate2' +
        ' ' +
        'تم الاتفاق بين كل من: ' +
        '\n' +
        'الطرف الأول:' +
        ' ' +
        userName +
        ' ' +
        'الجنسية:' +
        ' ' +
        userNationality +
        ' '
            'ويحمل' +
        ' ' +
        userType +
        ' '
            'رقم:' +
        ' ' +
        userIdNumber +
        ' ' +
        'ب' +
        userVerifiedType +
        ' ' +
        'بموجب التوثيق' +
        ' ' +
        'برقم' +
        ' ' +
        userVerifiedNumber +
        ' ' +
        'بمقر المملكة العربية السعودية – مدينة:' +
        ' ' +
        userCityName +
        ' ' +
        '، رقم الاتصال:' +
        ' ' +
        userPhone +
        ' ' +
        'البريد الإلكتروني:' +
        ' ' +
        userEmail +
        '\n' +
        'والطرف الثاني:' +
        ' ' +
        celerityName +
        ' ' +
        'الجنسية:' +
        ' ' +
        celerityNationality +
        ' ' +
        'ويحمل' +
        ' ' +
        celpType +
        ' ' +
        'رقم:' +
        ' ' +
        celerityIdNumber +
        ' ' +
        'ب' +
        celerityVerifiedType +
        ' ' +
        ' بموجب التوثيق' +
        ' ' +
        'برقم' +
        ' ' +
        celerityVerifiedNumber +
        ' ' +
        'بمقر المملكة العربية السعودية – مدينة:' +
        ' ' +
        celerityCityName +
        ' ' +
        '، رقم الاتصال:' +
        ' ' +
        celerityPhone +
        ' ' +
        'البريد الإلكتروني:' +
        ' ' +
        celerityEmail;
//========================================================================
    String pragraf2 = "حيث أن الطرف الأول يملك ${userVerifiedType} ولديه رغبة في العمل " +
        " والتعاون مع الطرف الثاني في قيامه بالتسويق الالكتروني عبر المنصة منصات المشاهير ولما لدى الطرف " +
        " الثاني من شعبيه إعلاميه وعدد كبير من المتابعين في حساباته الرسميه في صفحات التواصل الاجتماعي الرقمي" +
        " ويحمل جميع المؤهلات والتراخيص اللازمة والنظامية ولديه جميع الوسائل المشروعة لانجاز العمل في الإعلان " +
        " التجاري ولما لديه من استعداد بذلك في حسابه ${platform} وقد قام الطرفان بفحص جميع الاوراق اللازمة " +
        " والنظامية المترتبة على ذلك فيما بينهما لانعقاد هذا الاتفاق فيما يخص الأنظمة والقوانين السعوديه ذات العلاقة . " +
        " وعليه قد اتفق الطرفين وهما بكامل أهليتهما والأوصاف المعتبرة شرعًا والأهلية القانونية في التعاقد والتصرف، " +
        " وقد تم الاتفاق على البنود التالية:";
//========================================================================
    String pragraf3 =
        "أن يعمل الطرف الثاني في الدعاية والإعلان والتسويق التجاري لشخصه عبر الاعلام المرئي والمسموع وذلك عبر قنواته وحساباته في صفحات التواصل الاجتماعي )السناب شات ؛ تيك توك ؛ استقرام ؛ تويتر ؛ الانستا؛ يوتيوب .. الخ( وبناء عليه وعلى طلب الطرف الأول للتفاوض +فيما بيننا عن طريق المنصة منصات المشاهير في تقديم المحتوى الاعلامي ";
//========================================================================
    String pragraf4Adv =
        "اتفق الطرفين أن مده العمل تبدأ من تاريخ توقيع هذا العقد؛ عبر صفحة التواصل ${platform}";

    String pragraf4Space =
        "اتفق الطرفين أن مده العمل تبدأ من تاريخ توقيع هذا العقد";

//========================================================================

    String pragraf5Space = "رابط صفحة المعلن:\n" +
        " $advLink\n"
            "صفة الاعلان:" +
        "  " +
        "$advOrAdvSpace\n"
            "تاريخ الاعلان:" +
        "  " +
        "$advDate\n"
            "عرض الإعلان لمرة واحدة فقط.";
//======================================================================================================
    String pragrafAdv = "الوصف الخاص بالاعلان:\n" +
        " $advDescription\n"
            "صفة الاعلان:" +
        "  " +
        "$advOrAdvSpace\n"
            "نوع الاعلان:" +
        "  " +
        "$advProductOrService\n"
            "توقيت الاعلان:" +
        "  " +
        "$advTime\n"
            "تاريخ الاعلان:" +
        "  " +
        "$advDate\n"
            "عرض الإعلان لمرة واحدة فقط.";
//========================================================================
    String pragraf6_1 = "اتفق الطرفين على: \n"
            "١-"
            "أن يكون حساب والمبلغ المالي للطرف الثاني من قيمه عمولته المتفق عليها من الطرف الأول تتحول للمنصة عبر حسابه المنصوص في العقد بينه وبين المنصة منصات المشاهير على أن يحول له بعد اتمام العمل كاملاً خلال المده المحدده وبعد اعتماد الطرف الأول له." +
        "\n";
    String pragraf6_2 = "-٢ "
            "يتم تعميد الحسابات البنكية التجارية للطرفين المسجلة في المنصة تودع فيه أمواله الناتجة منه أو إليه" +
        "\n" +
        "-٣ "
            "تصدر الفواتير التجارية المعتمده من شركه متخصصة متعاقده مع الطرف المنصه منصات المشاهير." +
        "\n" +
        "";
//========================================================================
    String pragraf7 =
        "اتفق الطرفان على أنّ: حفظ ملكية واسرار معلومات وبيانات الطرف الأول وبيانات واسرار الطرف الثاني من السجلات التجارية وفروعها والحسابات والخدمات وآليات العمل التي يقوم بها الطرف الثاني ولا يفرط لأحدهما معلومات الآخر بذلك ولا تستخدم عن طريقهم بشىء غير مشروع نظاماً.";
//========================================================================
    String pragraf8 =
        "اتفق الطرفان على أن يكون بينهما مراسلات رقميه معتمده وهي (المنصه بكامل قنواتها والحسابات الرقميه في السوشل ميديا للطرفين) وجميع عناوين الطرفين والمدونه أعلاه ويعتبر عنوانا مشتركًا بينهما؛ ويحق للطرف الأول أن يسلم الطرف الثاني جميع الاشعارات والاخطارات عليه.";
//========================================================================
    String pragraf9_1 = "حقوق الطرف الأول:\n"
            "١- يحق للطرف الأول التعديل على المحتوى وطريقه تقديمه وتفاصيله من الطرف الثاني \n"
            "٢- يحق للطرف الأول عمل أكثر من عرض تجريبي خلال فتره العقد المبرمه بينهما "
            "واجبات الطرف الثاني:\n"
            "١- يلتزم الطرف الثاني باعطاء بياناته الشخصية والتجارية صحيحة من حيث الاسم ورقم هويته وعنوانه الوطني وبيانات السجل التجاري وجميع التراخيص والتصاريح والفسوح النظامية التي تخص ذات الشأن" +
        "\n";
    String pragraf9_2 =
        "٢- يلتزم الطرف الثاني بالتقيد بالأنظمة واللوائح السعودية التابعه لذات الشأن؛ ولا يخالف في محتواه الالكتروني والرقمي أحكام الشريعة الاسلامية ويكون ملماً بالأنظمة والقوانين السعودية وتطبيقاتها قبل امضاء هذا العقد وبجميع بنودها ونصوصها" +
            "\n"
                "٣- يلتزم الطرف الثاني مع الطرف الأول تعاوناً وذلك بالتقيد بسياسة المنصة وخصوصيتها ؛ ولا يتسبب في سوء الاستخدام  بأي خلل تقني في  المنصة الكترونيا بتاتا أو الإساءة لشخص اعتباري أو شخص معنوي يترتب عليها مخالفة على المنصة" +
            "\n"
                "٤- يلتزم الطرف الثاني مع الطرف الأول باعطاء مواعيد دقيقه وثابته في كل مايخص العمل بينهما وتقديم خدمة نوعية مميزة ومادة إعلامية جيدة وبطابع وأسلوب مبتكر وجميل ويحفظ بها سمعه الطرفين في السوق التجاري والاعلامي" +
            "\n"
                "٥- لا يحق للطرف الثاني افشاء أي معلومات او بيانات او استخدام اكواد او مصادر بعد فسخ العقد مع الطرف الأول والمنصه مع أي جهة أخرى" +
            "\n";
//========================================================================
    String pragraf10_1 =
        "١- عند تأخر انتاج وعرض المحتوى من الطرف الثاني بعد ابلاغ الطرف الأول للمنصة بذلك فيعطى انذار و….. وان تكرر مره أخرى يدفع غرامه الضرر وقدرها …. والمره الثالثه يلغى حسابه بالمنصه" +
            "\n" +
            "٢- أي خلل نظامي أو خطأ من الطرف الأول والطرف الثاني عبر المنصة وعبر محتواه في حساباته الرسميه نتج عنه ضرر معنوي او مادي أونتج عنه مخالفه نظامية للأنظمه السعوديه وهيئاتها الحكومية على الطرف الأول أو من قبل الطرف الثاني فيتحمله المخالف لها أو يكون سوياً على حسب نسبه الخطأ" +
            "\n";
    String pragraf10_2 =
        "٣- أي خلاف ينشأ بين طرفي العقد بشكل نظامي أو بسبب تنفيذه أو تفسيره أو مافيه افشاء اسرار الآخر فيتم حله ودياً، ويلحق بذلك ملحق عقد إن لزم الامر. فإذا تعذر ذلك فيعرض النزاع على لجان الصلح المختصة أوالمحكمة المختصة في محافظة جدة – المملكة العربية السعودية" +
            "\n";
    String pragraf10_3 =
        "٤- كل ما لم يرد بشـأنه في هذا العقد يطبق عليه الأنظمة التجارية والأنظمة المختصة وبكل لوائحها والمعمول بها في المملكة العربية السعودية" +
            "\n";
//========================================================================
    String pragraf11 =
        "تم تحرير نسختين من هذا العقد، ويحتوي هذا العقد على ثمانية بنود أساسية ومختلف النقاط الفرعية، كما يحصل كل طرف على نسخة منه سواء كانت هذه النسخة الكترونيًا أو غير ذلك.";
//========================================================================
    final pdf = Document(
        //pageMode: PdfPageMode.outlines,
        version: PdfVersion.pdf_1_5,
        compress: false);
    pdf.addPage(
      MultiPage(
          margin:
          const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),
          //pageTheme: ,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          header:(context) {

            return Center(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Image(imageImage, fit: BoxFit.contain,dpi:100 )
                ));
          },
          footer: (context) {
            final pages = "${context.pageNumber}";
            //   " من "+
            //  "${context.pagesCount} ";

            return Center(
                child: Text(pages, style: const TextStyle(fontSize: 15)));
          },
          theme: ThemeData.withFont(
            base: arabicFont,
          ),
          pageFormat: format,
          textDirection: TextDirection.rtl,
          build: (context) => [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      showParagraph(pragraf1),
                      SizedBox(height: 10),
                      showText('المقدمه والتمهيد'),
                      showParagraph(pragraf2),
                      // SizedBox(height: 10),
                      showText('البند الأول ' + ')' + 'المقدمة والتمهيد' + '('),
                      showParagraph(
                          "المقدمة والتمهيد لهذا العقد أعلاه يعتبر جزء لا يتجزأ من الاتفاق. "),
                      SizedBox(height: 10),
                      showText(
                          'البند الثاني ' + ')' + 'الغرض من الاتفاقية' + '('),
                      showParagraph(pragraf3),

                      SizedBox(height: 10),
                      showText('البند الثالث ' + ')' + 'مده التعاقد' + '('),
                      advOrAdvSpace == "إعلان"
                          ? showParagraph(pragraf4Adv + "\n" + pragrafAdv)
                          : showParagraph(pragraf4Space + "\n" + pragraf5Space),
                      SizedBox(height: 10),
                      showText(
                          'البند الرابع ' + ')' + 'الحصص والتصرف المالي' + '('),
                      showParagraph(pragraf6_1),
                      showParagraph(pragraf6_2),
                      SizedBox(height: 10),
                      showText(
                          'البند الخامس ' + ')' + 'الخصوصية والأمان' + '('),
                      showParagraph(pragraf7),
                      SizedBox(height: 10),
                      showText(
                          'البند السادس ' + ')' + 'الاخطارات والتبليغات' + '('),
                      showParagraph(pragraf8 + "\n"),
                      showParagraph(pragraf9_1),
                      showParagraph(pragraf9_2),
                      SizedBox(height: 10),
                      showText(
                          'البند السابع ' + ')' + 'شروط وأحكام عامه' + '('),
                      showParagraph(pragraf10_1),
                      showParagraph(pragraf10_2),
                      showParagraph(pragraf10_3),
                      SizedBox(height: 10),
                      showText('البند الثامن ' + ')' + 'تحرير العقد' + '('),
                      showParagraph(pragraf11),

                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Paragraph(text: "الطرف الثاني"),
                                  Paragraph(text: "الاسم: $celerityName"),
                                  Paragraph(text: "التوقيع"),
                                  celeritySigntion == "" ||
                                          celeritySigntion == null
                                      ? SizedBox(
                                          height: 60,
                                          width: 100,
                                        )
                                      : Image(MemoryImage(dataCelp),
                                          fit: BoxFit.contain,
                                          height: 60,
                                          width: 100),
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Paragraph(text: "الطرف الاول"),
                                  Paragraph(text: "الاسم: $userName"),
                                  Paragraph(text: "التوقيع"),
                                  userSingture == "" || userSingture == null
                                      ? SizedBox(
                                          height: 60,
                                          width: 100,
                                        )
                                      : Image(MemoryImage(dataUser),
                                          fit: BoxFit.contain,
                                          height: 60,
                                          width: 100),
                                ]),
                          ])
                    ])
              ]),
    );

    return pdf.save();
    //saveDocument(name: 'contract.pdf', pdf: pdf);
  }

  //generateContract between celebrate and application=============================================================
  static Future<Uint8List> generateContractSingUP({
    // required String celerityName,
    // required String celerityIdNumber,
    // required String celerityNationality,
    // required String celerityVerifiedType,
    // required String celerityVerifiedNumber,
    // required String celerityCityName,
    // required String celerityPhone,
    // required String celerityEmail,
    // required String userName,
    // required String userIdNumber,
    // required String userNationality,
    // required String userVerifiedType,
    // required String userVerifiedNumber,
    // required String userCityName,
    // required String userPhone,
    // required String userEmail,
    // required String platform,
    // required String advDescription,
    // required String advLink,
    // required String advTime,
    // required String advProductOrService,
    // required String advOrAdvSpace,
    // required String advDate,
    // required String? celeritySigntion,
    // required String? userSingture,
    // String? sendDate,
    PdfPageFormat? format,
  }) async {
    var arabicFont = Font.ttf(
        await rootBundle.load("assets/font/DINNextLTArabic-Regular-2.ttf"));
    var imageImage = MemoryImage(
        (await rootBundle.load('assets/image/hedar.png')).buffer.asUint8List());

//========================================================================
    String pragraf2 = "حيث أن الطرف الأول يملك ولديه رغبة في العمل " +
        " والتعاون مع الطرف الثاني في قيامه بالتسويق الالكتروني عبر المنصة منصات المشاهير ولما لدى الطرف " +
        " الثاني من شعبيه إعلاميه وعدد كبير من المتابعين في حساباته الرسميه في صفحات التواصل الاجتماعي الرقمي" +
        " ويحمل جميع المؤهلات والتراخيص اللازمة والنظامية ولديه جميع الوسائل المشروعة لانجاز العمل في الإعلان " +
        " التجاري ولما لديه من استعداد بذلك في حسابه  وقد قام الطرفان بفحص جميع الاوراق اللازمة " +
        " والنظامية المترتبة على ذلك فيما بينهما لانعقاد هذا الاتفاق فيما يخص الأنظمة والقوانين السعوديه ذات العلاقة . " +
        " وعليه قد اتفق الطرفين وهما بكامل أهليتهما والأوصاف المعتبرة شرعًا والأهلية القانونية في التعاقد والتصرف، " +
        " وقد تم الاتفاق على البنود التالية:";
//========================================================================
    String pragraf3 =
        "أن يعمل الطرف الثاني في الدعاية والإعلان والتسويق التجاري لشخصه عبر الاعلام المرئي والمسموع وذلك عبر قنواته وحساباته في صفحات التواصل الاجتماعي )السناب شات ؛ تيك توك ؛ استقرام ؛ تويتر ؛ الانستا؛ يوتيوب .. الخ( وبناء عليه وعلى طلب الطرف الأول للتفاوض +فيما بيننا عن طريق المنصة منصات المشاهير في تقديم المحتوى الاعلامي ";
//========================================================================
    String pragraf4Adv =
        "اتفق الطرفين أن مده العمل تبدأ من تاريخ توقيع هذا العقد؛ عبر صفحة التواصل";

    String pragraf4Space =
        "اتفق الطرفين أن مده العمل تبدأ من تاريخ توقيع هذا العقد";

//========================================================================
    String pragraf6_1 = "اتفق الطرفين على: \n"
            "١-"
            "أن يكون حساب والمبلغ المالي للطرف الثاني من قيمه عمولته المتفق عليها من الطرف الأول تتحول للمنصة عبر حسابه المنصوص في العقد بينه وبين المنصة منصات المشاهير على أن يحول له بعد اتمام العمل كاملاً خلال المده المحدده وبعد اعتماد الطرف الأول له." +
        "\n";
    String pragraf6_2 = "-٢ "
            "يتم تعميد الحسابات البنكية التجارية للطرفين المسجلة في المنصة تودع فيه أمواله الناتجة منه أو إليه" +
        "\n" +
        "-٣ "
            "تصدر الفواتير التجارية المعتمده من شركه متخصصة متعاقده مع الطرف المنصه منصات المشاهير." +
        "\n" +
        "";
//========================================================================
    String pragraf7 =
        "اتفق الطرفان على أنّ: حفظ ملكية واسرار معلومات وبيانات الطرف الأول وبيانات واسرار الطرف الثاني من السجلات التجارية وفروعها والحسابات والخدمات وآليات العمل التي يقوم بها الطرف الثاني ولا يفرط لأحدهما معلومات الآخر بذلك ولا تستخدم عن طريقهم بشىء غير مشروع نظاماً.";
//========================================================================
    String pragraf8 =
        "اتفق الطرفان على أن يكون بينهما مراسلات رقميه معتمده وهي (المنصه بكامل قنواتها والحسابات الرقميه في السوشل ميديا للطرفين) وجميع عناوين الطرفين والمدونه أعلاه ويعتبر عنوانا مشتركًا بينهما؛ ويحق للطرف الأول أن يسلم الطرف الثاني جميع الاشعارات والاخطارات عليه.";
//========================================================================
    String pragraf9_1 = "حقوق الطرف الأول:\n"
            "١- يحق للطرف الأول التعديل على المحتوى وطريقه تقديمه وتفاصيله من الطرف الثاني \n"
            "٢- يحق للطرف الأول عمل أكثر من عرض تجريبي خلال فتره العقد المبرمه بينهما "
            "واجبات الطرف الثاني:\n"
            "١- يلتزم الطرف الثاني باعطاء بياناته الشخصية والتجارية صحيحة من حيث الاسم ورقم هويته وعنوانه الوطني وبيانات السجل التجاري وجميع التراخيص والتصاريح والفسوح النظامية التي تخص ذات الشأن" +
        "\n";
    String pragraf9_2 =
        "٢- يلتزم الطرف الثاني بالتقيد بالأنظمة واللوائح السعودية التابعه لذات الشأن؛ ولا يخالف في محتواه الالكتروني والرقمي أحكام الشريعة الاسلامية ويكون ملماً بالأنظمة والقوانين السعودية وتطبيقاتها قبل امضاء هذا العقد وبجميع بنودها ونصوصها" +
            "\n"
                "٣- يلتزم الطرف الثاني مع الطرف الأول تعاوناً وذلك بالتقيد بسياسة المنصة وخصوصيتها ؛ ولا يتسبب في سوء الاستخدام  بأي خلل تقني في  المنصة الكترونيا بتاتا أو الإساءة لشخص اعتباري أو شخص معنوي يترتب عليها مخالفة على المنصة" +
            "\n"
                "٤- يلتزم الطرف الثاني مع الطرف الأول باعطاء مواعيد دقيقه وثابته في كل مايخص العمل بينهما وتقديم خدمة نوعية مميزة ومادة إعلامية جيدة وبطابع وأسلوب مبتكر وجميل ويحفظ بها سمعه الطرفين في السوق التجاري والاعلامي" +
            "\n"
                "٥- لا يحق للطرف الثاني افشاء أي معلومات او بيانات او استخدام اكواد او مصادر بعد فسخ العقد مع الطرف الأول والمنصه مع أي جهة أخرى" +
            "\n";
//========================================================================
    String pragraf10_1 =
        "١- عند تأخر انتاج وعرض المحتوى من الطرف الثاني بعد ابلاغ الطرف الأول للمنصة بذلك فيعطى انذار و….. وان تكرر مره أخرى يدفع غرامه الضرر وقدرها …. والمره الثالثه يلغى حسابه بالمنصه" +
            "\n" +
            "٢- أي خلل نظامي أو خطأ من الطرف الأول والطرف الثاني عبر المنصة وعبر محتواه في حساباته الرسميه نتج عنه ضرر معنوي او مادي أونتج عنه مخالفه نظامية للأنظمه السعوديه وهيئاتها الحكومية على الطرف الأول أو من قبل الطرف الثاني فيتحمله المخالف لها أو يكون سوياً على حسب نسبه الخطأ" +
            "\n";
    String pragraf10_2 =
        "٣- أي خلاف ينشأ بين طرفي العقد بشكل نظامي أو بسبب تنفيذه أو تفسيره أو مافيه افشاء اسرار الآخر فيتم حله ودياً، ويلحق بذلك ملحق عقد إن لزم الامر. فإذا تعذر ذلك فيعرض النزاع على لجان الصلح المختصة أوالمحكمة المختصة في محافظة جدة – المملكة العربية السعودية" +
            "\n";
    String pragraf10_3 =
        "٤- كل ما لم يرد بشـأنه في هذا العقد يطبق عليه الأنظمة التجارية والأنظمة المختصة وبكل لوائحها والمعمول بها في المملكة العربية السعودية" +
            "\n";
//========================================================================
    String pragraf11 =
        "تم تحرير نسختين من هذا العقد، ويحتوي هذا العقد على ثمانية بنود أساسية ومختلف النقاط الفرعية، كما يحصل كل طرف على نسخة منه سواء كانت هذه النسخة الكترونيًا أو غير ذلك.";
//========================================================================
    final pdf = Document(
        //pageMode: PdfPageMode.outlines,
        version: PdfVersion.pdf_1_5,
        compress: false);
    pdf.addPage(
      MultiPage(
          margin:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 0),

          //pageTheme: ,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          header:(context) {

            return Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Image(imageImage, fit: BoxFit.contain,dpi:100 )
                ));
          },
          footer: (context) {
            final pages = "${context.pageNumber}";
            //   " من "+
            //  "${context.pagesCount} ";

            return Center(
                child: Text(pages, style: const TextStyle(fontSize: 15)));
          },
          theme: ThemeData.withFont(
            base: arabicFont,
          ),
          pageFormat: format,
          textDirection: TextDirection.rtl,
          // margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          // padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
          build: (context) => [

               Column(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     // Header(
                     //   child: Image(imageImage, fit: BoxFit.contain),
                     // ),

                     showText('المقدمه والتمهيد'),
                     showParagraph(pragraf2),
                     // SizedBox(height: 10),
                     showText('البند الأول ' + ')' + 'المقدمة والتمهيد' + '('),
                     showParagraph(
                         "المقدمة والتمهيد لهذا العقد أعلاه يعتبر جزء لا يتجزأ من الاتفاق. "),
                     SizedBox(height: 10),
                     showText(
                         'البند الثاني ' + ')' + 'الغرض من الاتفاقية' + '('),
                     showParagraph(pragraf3),

                     SizedBox(height: 10),
                     showText('البند الثالث ' + ')' + 'مده التعاقد' + '('),

                     showParagraph(pragraf4Space),
                     SizedBox(height: 10),
                     showText(
                         'البند الرابع ' + ')' + 'الحصص والتصرف المالي' + '('),
                     showParagraph(pragraf6_1),
                     showParagraph(pragraf6_2),
                     SizedBox(height: 10),
                     showText(
                         'البند الخامس ' + ')' + 'الخصوصية والأمان' + '('),
                     showParagraph(pragraf7),
                     SizedBox(height: 10),
                     showText(
                         'البند السادس ' + ')' + 'الاخطارات والتبليغات' + '('),
                     showParagraph(pragraf8 + "\n"),
                     showParagraph(pragraf9_1),
                     showParagraph(pragraf9_2),
                     SizedBox(height: 10),
                     showText(
                         'البند السابع ' + ')' + 'شروط وأحكام عامه' + '('),
                     showParagraph(pragraf10_1),
                     showParagraph(pragraf10_2),
                     showParagraph(pragraf10_3),
                     SizedBox(height: 10),
                     showText('البند الثامن ' + ')' + 'تحرير العقد' + '('),
                     showParagraph(pragraf11),

                     Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Paragraph(text: "التوقيع"),
                                 SizedBox(
                                   height: 60,
                                   width: 100,
                                 )
                               ]),
                         ])
                   ])
              ]),
    );

    return pdf.save();
    //saveDocument(name: 'contract.pdf', pdf: pdf);
  }

//save file in device======================================================================
  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

//=======================================================================================
//save file in device======================================================================
  static Future<File> getDocumentPdf(
      {String name = 'contract.pdf', required Uint8List bytes}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openPdf(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  //Paragraph==================================================================================================
  static Widget showParagraph(String text,
      {double fontSize = 18, PdfColor color = PdfColors.black}) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Paragraph(
            text: text,
            textAlign: TextAlign.justify,
            margin: const EdgeInsets.only(bottom: 7.0 * PdfPageFormat.mm),
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                wordSpacing: 1,
                //fontBold:Font.timesBold() ,
                lineSpacing: 2)));
  }

//text==================================================================================================
  static Widget showText(String text,
      {double fontSize = 22, PdfColor color = PdfColors.black}) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Text(text,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: fontSize,
                color: color,
                wordSpacing: 1,
                fontBold: Font.timesBold(),
                lineSpacing: 2)));
  }
}
