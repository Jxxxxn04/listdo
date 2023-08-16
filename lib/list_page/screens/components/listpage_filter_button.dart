import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class ListPageFilterButton extends StatefulWidget {
  const ListPageFilterButton({super.key, required this.listColor});

  final Color listColor;

  @override
  State<ListPageFilterButton> createState() => _ListPageFilterButtonState();
}

class _ListPageFilterButtonState extends State<ListPageFilterButton> {

  bool _isExtended = false;

  int _countOfSelectedCategories = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        animatedContainer(),
        SizedBox(
          height: 3.h,
          width: 35.w,
          child: Material(
            elevation: 5,
            color: widget.listColor,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            child: InkWell(
              onTap: changeStatus,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              child: Center(
                child: AnimatedCrossFade(
                    firstChild: Icon(Icons.arrow_upward_outlined, color: Colors.white, size: 18.sp,),
                    secondChild: Icon(Icons.arrow_downward_outlined, color: Colors.white, size: 18.sp,),
                    crossFadeState: _isExtended ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 250)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void changeStatus() {
    setState(() {
      _isExtended = !_isExtended;
    });
  }


  Widget animatedContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      height: _isExtended ? 50.h : 0.h,
      width: 100.h,
      child: Material(
        color: widget.listColor,
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 2.h,),
              _lineWithWord("Filter", 3.h),
              SizedBox(height: 2.h,),
              _selectCategories(),
              SizedBox(height: 3.h,),
              CustomRadioButton()
            ],
          ),
        ),
      ),
    );
  }




  Widget _lineWithWord (String word, double height) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 1.w),
              child: const Divider(
                thickness: 1.0,
                endIndent: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            word,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 1.w),
              child: const Divider(
                thickness: 1.0,
                indent: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectCategories() {
    return Row(
      children: [
        Text(
          "Kategorie:",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12.sp
          ),
        ),
        // TODO : DropDownMenu Multipleselection
      ],
    );
  }




}

class CustomRadioButton extends StatefulWidget {
  const CustomRadioButton({super.key});

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  // Initialize currentOption in initState
  late String currentOption;

  List<String> options = ["vorhandene", "erledigte"];

  @override
  void initState() {
    super.initState();
    // Move the initialization here
    currentOption = options[0]; // Initialize to the default value
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        RadioListTile(
          title: const Text("Vorhandene Einträge"),
          value: options[0],
          groupValue: currentOption,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            print(value);
            setState(() {

              // TODO : Liste akutalisieren mit vorhandenen Aufträgen

              currentOption = value.toString();
            });
          },
        ),
        RadioListTile(
          title: const Text("Erledigte Einträge"),
          value: options[1],
          groupValue: currentOption,
          controlAffinity: ListTileControlAffinity.trailing,
          onChanged: (value) {
            print(value);
            setState(() {

              // TODO : Liste akutalisieren mit erledigten Aufträgen

              currentOption = value.toString();
            });
          },
        )
      ],
    );
  }
}

