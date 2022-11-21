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
String pragraf5="$advDescription""\n""$advLink""\n""$advOrAdvSpace\n$advProductOrService\n$advTime\n$advDate""\n""عرض الإعلان لمرة واحدة فقط.";
//========================================================================
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
            final pages = "الصفحة" + " " + "${context.pageNumber} ";
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
      {double fontSize = 18, PdfColor color = PdfColors.black}) {
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
