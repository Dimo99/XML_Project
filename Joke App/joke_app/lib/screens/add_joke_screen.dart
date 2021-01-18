import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:joke_app/provider/joke_provider.dart';
import 'package:joke_app/utils/colors.dart';
import 'package:provider/provider.dart';

class AddJokeScreen extends StatefulWidget {
  @override
  _AddJokeScreenState createState() => _AddJokeScreenState();
}

class _AddJokeScreenState extends State<AddJokeScreen> {
  int categoryIndex;

  final _textFieldKey = GlobalKey<FormFieldState<String>>();

  final _fieldController = TextEditingController();

  final _focusNode = FocusNode();

  final _hintStyle = const TextStyle(
    color: Color.fromRGBO(142, 142, 147, 1),
    fontSize: 20,
  );

  final _textStyle = const TextStyle(
    color: Colors.black45,
    fontSize: 20,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _fieldController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbar,
      ),
      backgroundColor: Colors.transparent,
      body: Consumer<JokeProvider>(
        builder: (context, provider, child) {
          List<Map<String, dynamic>> items = <Map<String, dynamic>>[];

          for (int i = 0; i < provider.categoryData.length; ++i) {
            items.add({
              'value': i.toString(),
              'label': provider.categoryData[i],
            });
          }

          return Container(
            color: background,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      icon: Icon(Icons.category),
                      labelText: 'Category',
                      items: items,
                      onChanged: (val) {
                        setState(() {
                          categoryIndex = int.parse(val);
                        });
                      },
                      style: _textStyle,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      key: _textFieldKey,
                      focusNode: _focusNode,
                      controller: _fieldController,
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.multiline,
                      style: _textStyle,
                      textAlignVertical: TextAlignVertical.center,
                      minLines: 5,
                      maxLines: 8,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black54),
                        ),
                        hintText: "Content",
                        hintStyle: _hintStyle,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: 40),
                ),
                SliverToBoxAdapter(
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Icon(Icons.add, size: 40),
                    ),
                    onTap: () => addJoke(context, provider),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void addJoke(BuildContext context, JokeProvider provider) {
    if (categoryIndex != null && _fieldController.text != null && _fieldController.text.isNotEmpty) {
      provider.addJoke(categoryIndex, _fieldController.text);
      Navigator.of(context).pop();
    }
  }
}
