import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetaking_dapp/controllers/note_controller.dart';
import 'package:notetaking_dapp/models/note.dart';
import 'package:notetaking_dapp/screens/home_screen.dart';
import 'package:notetaking_dapp/utils/themes.dart';
import 'package:provider/provider.dart';

class NotesEditScreen extends StatefulWidget {
  final Note note;
  NotesEditScreen({
    Key key,
    this.note,
  }) : super(key: key);

  @override
  _NotesEditScreenState createState() => _NotesEditScreenState();
}

class _NotesEditScreenState extends State<NotesEditScreen> {
  TextEditingController _titleCtrl;
  TextEditingController _bodyCtrl;
  NoteController noteController;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(
        text: widget.note != null ? widget.note.title : '');
    _bodyCtrl = TextEditingController(
        text: widget.note != null ? widget.note.body : '');
  }

  handleCreateNote(dep) async {
    Note note = new Note(
      title: _titleCtrl.text,
      body: dep,
      created: new DateTime.now(),
    );
    await noteController.addNote(note);
  }

  handleEditNote() async {
    Note note = new Note(
      id: widget.note.id,
      title: _titleCtrl.text,
      body: _bodyCtrl.text,
    );
    await noteController.editNote(note);
  }

  var col;
  var dep;
  Widget buttonbox(name, num) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          dep = name;
          col = num;
          setState(() {});
        },
        child: Material(
          elevation: 20,
          color: col == num ? Colors.greenAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 50,
            width: 100,
            child: Center(
              child: Text(
                name,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    noteController = Provider.of<NoteController>(context);
    return Scaffold(
      backgroundColor: ColorConstant.bg,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: noteController.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ColorConstant.bgAccent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (widget.note == null)
                                  handleCreateNote(dep);
                                else
                                  handleEditNote();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => HomeScreen()),
                                    (route) => false);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorConstant.bgAccent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  widget.note == null ? "Add" : "Update",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[100],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _titleCtrl,
                          style: GoogleFonts.montserrat(
                            fontSize: 36,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: " Title",
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.montserrat(
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        buttonbox("IncomeTax", 1),
                        buttonbox("Police", 2),
                        buttonbox("ElectriCity", 3),
                        buttonbox("Education", 4),
                        buttonbox("MetroWater", 5),
                        buttonbox("Municipal", 6)
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
