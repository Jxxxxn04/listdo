import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';


class ListPageSearchButton extends StatefulWidget {
  const ListPageSearchButton({super.key, required this.listColor});

  final Color listColor;

  @override
  State<ListPageSearchButton> createState() => _ListPageSearchButtonState();
}

class _ListPageSearchButtonState extends State<ListPageSearchButton> {

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

  void extendSearchContainer() {
    setState(() {
      _isExtended = true;
    });

    // TODO : Searchbar ausfahren

  }

  void shrinkSearchContainer() {
    setState(() {
      _isExtended = false;
    });

    // TODO : Searchbar einfahren

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
              _radioListButtons(),
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

  Widget _radioListButtons() {
    List<String> options = ['Vorhandene Einträge', 'Erledigte Einträge'];
    String currentOption = options[0];

    return Column(
      children: [
        RadioListTile(
          title: const Text("Vorhandene Einträge"),
          value: options[0],
          groupValue: currentOption,
          onChanged: (value) {
            print(value);
            setState(() {
              currentOption = value.toString();
            });
          },),
        RadioListTile(
          title: const Text("Erledigte Einträge"),
          value: options[1],
          groupValue: currentOption,
          onChanged: (value) {
            print(value);
            setState(() {
              currentOption = value.toString();
            });
          },)
      ],
    );
  }


}