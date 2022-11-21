import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

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
    PdfPageFormat? format,
  }) async {
    String userType = userNationality == 'سعودي' ? 'إقامة' : 'هوية';
    String celpType = celerityNationality == 'سعودي' ? 'إقامة' : 'هوية';
    var arabicFont = Font.ttf(
        await rootBundle.load("assets/font/DINNextLTArabic-Regular-2.ttf"));
    var imageImage = MemoryImage(
        (await rootBundle.load('assets/image/hedar.png')).buffer.asUint8List());
    String pragraf1 = 'انه في يوم' +
        ' ' +
        '${date.day}-${date.month}-${date.year}' +
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
    String pragraf2 = "حيث أن الطرف الأول يملك ${userVerifiedType} ؛ ولديه رغبة في العمل " +
        "والتعاون مع الطرف الثاني في قيامه بالتسويق الالكتروني عبر المنصة منصات المشاهير؛ ولما لدى الطرف " +
        "الثاني من شعبيه إعلاميه وعدد كبير من المتابعين في حساباته الرسميه في صفحات التواصل الاجتماعي الرقمي" +
        "ويحمل جميع المؤهلات والتراخيص اللازمة والنظامية ولديه جميع الوسائل المشروعة لانجاز العمل في الإعلان " +
        "التجاري ولما لديه من استعداد بذلك في حسابه ${platform} وقد قام الطرفان بفحص جميع الاوراق اللازمة " +
        "والنظامية المترتبة على ذلك فيما بينهما لانعقاد هذا الاتفاق فيما يخص الأنظمة والقوانين السعوديه ذات العلاقة . " +
        "وعليه قد اتفق الطرفين وهما بكامل أهليتهما والأوصاف المعتبرة شرعًا والأهلية القانونية في التعاقد والتصرف، " +
        "وقد تم الاتفاق على البنود التالية:";
//========================================================================
    String pragraf3 =
        "أن يعمل الطرف الثاني في الدعاية والإعلان والتسويق التجاري لشخصه عبر الاعلام المرئي والمسموع وذلك عبر قنواته وحساباته في صفحات التواصل الاجتماعي )السناب شات ؛ تيك توك ؛ استقرام ؛ تويتر ؛ الانستا؛ يوتيوب .. الخ( وبناء عليه وعلى طلب الطرف الأول للتفاوض +فيما بيننا عن طريق المنصة منصات المشاهير في تقديم المحتوى الاعلامي ";
//========================================================================
String pragraf4="اتفق الطرفين أن مده العمل تبدأ من تاريخ توقيع هذا العقد؛ عبر صفحة التواصل ${platform}";
//========================================================================
String pragraf5=  "الوصف الخاص بالاعلان:\n"+
" $advDescription\n"
"رابط صفحة المعلن:\n"+" $advLink\n"
"صفة الاعلان:"+"  "+"$advOrAdvSpace\n"
"نوع الاعلان:"+"  "+"$advProductOrService\n"
"توقيت الاعلان:"+"  "+"$advTime\n"
"تاريخ الاعلان:"+"  "+"$advDate\n"
"عرض الإعلان لمرة واحدة فقط.";
//========================================================================
String pragraf6="اتفق الطرفين على: \n"
"١-"
"أن يكون حساب والمبلغ المالي للطرف الثاني من قيمه عمولته المتفق عليها من الطرف الأول تتحول للمنصة عبر حسابه المنصوص في العقد بينه وبين المنصة منصات المشاهير على أن يحول له بعد اتمام العمل كاملاً خلال المده المحدده وبعد اعتماد الطرف الأول له."+"\n"+"-٢ "
"يتم تعميد الحسابات البنكية التجارية للطرفين المسجلة في المنصة تودع فيه أمواله الناتجة منه أو إليه"+"\n"+"-٣ "
"تصدر الفواتير التجارية المعتمده من شركه متخصصة متعاقده مع الطرف المنصه منصات المشاهير."+"\n"+
"";
//========================================================================
String pragraf7="اتفق الطرفان على أنّ: حفظ ملكية واسرار معلومات وبيانات الطرف الأول وبيانات واسرار الطرف الثاني من السجلات التجارية وفروعها والحسابات والخدمات وآليات العمل التي يقوم بها الطرف الثاني ولا يفرط لأحدهما معلومات الآخر بذلك ولا تستخدم عن طريقهم بشىء غير مشروع نظاماً.";
//========================================================================
String pragraf8="اتفق الطرفان على أن يكون بينهما مراسلات رقميه معتمده وهي (المنصه بكامل قنواتها والحسابات الرقميه في السوشل ميديا للطرفين) وجميع عناوين الطرفين والمدونه أعلاه ويعتبر عنوانا مشتركًا بينهما؛ ويحق للطرف الأول أن يسلم الطرف الثاني جميع الاشعارات والاخطارات عليه.";
//========================================================================
String pragraf9=
"حقوق الطرف الأول:\n"
"١- يحق للطرف الأول التعديل على المحتوى وطريقه تقديمه وتفاصيله من الطرف الثاني \n"
"٢- يحق للطرف الأول عمل أكثر من عرض تجريبي خلال فتره العقد المبرمه بينهما "
"واجبات الطرف الثاني:\n"
"١- يلتزم الطرف الثاني باعطاء بياناته الشخصية والتجارية صحيحة من حيث الاسم ورقم هويته وعنوانه الوطني وبيانات السجل التجاري وجميع التراخيص والتصاريح والفسوح النظامية التي تخص ذات الشأن"+"\n"
"٢- يلتزم الطرف الثاني بالتقيد بالأنظمة واللوائح السعودية التابعه لذات الشأن؛ ولا يخالف في محتواه الالكتروني والرقمي أحكام الشريعة الاسلامية ويكون ملماً بالأنظمة والقوانين السعودية وتطبيقاتها قبل امضاء هذا العقد وبجميع بنودها ونصوصها"+"\n"
"٣- يلتزم الطرف الثاني مع الطرف الأول تعاوناً وذلك بالتقيد بسياسة المنصة وخصوصيتها ؛ ولا يتسبب في سوء الاستخدام  بأي خلل تقني في  المنصة الكترونيا بتاتا أو الإساءة لشخص اعتباري أو شخص معنوي يترتب عليها مخالفة على المنصة" +"\n"
"٤- يلتزم الطرف الثاني مع الطرف الأول باعطاء مواعيد دقيقه وثابته في كل مايخص العمل بينهما وتقديم خدمة نوعية مميزة ومادة إعلامية جيدة وبطابع وأسلوب مبتكر وجميل ويحفظ بها سمعه الطرفين في السوق التجاري والاعلامي"+"\n"
"٥- لا يحق للطرف الثاني افشاء أي معلومات او بيانات او استخدام اكواد او مصادر بعد فسخ العقد مع الطرف الأول والمنصه مع أي جهة أخرى"+"\n"
;
//========================================================================
//========================================================================
//========================================================================
    final pdf = Document(
        pageMode: PdfPageMode.fullscreen,
        version: PdfVersion.pdf_1_5,
        compress: false);
    pdf.addPage(
      MultiPage(
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
          //pageTheme: ,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
                      Header(
                        child: Image(imageImage, fit: BoxFit.contain),
                      ),
                    
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
                      showParagraph(pragraf4+"\n"+pragraf5),
                      SizedBox(height: 10),
                      showText('البند الرابع ' + ')' + 'الحصص والتصرف المالي' + '('),
                      showParagraph(pragraf6),
                      SizedBox(height: 10),
                      showText('البند الخامس ' + ')' + 'الخصوصية والأمان' + '('),
                      showParagraph(pragraf7),
                      SizedBox(height: 10),
                      showText('البند السادس ' + ')' + 'الاخطارات والتبليغات' + '('),
                      showParagraph(pragraf8+"\n"+pragraf9),

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
