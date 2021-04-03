import 'package:flutter/material.dart';
import 'modal/task_data.dart';
import 'package:http/http.dart'as http;
void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskThree()
  ));
}


class TaskThree extends StatefulWidget {
  @override
  _TaskThreeState createState() => _TaskThreeState();
}

class _TaskThreeState extends State<TaskThree> {

  User _user;
  bool isLoading = false;
  int addData = 10;
  ScrollController scrollController = ScrollController();
  Future<User> fetchData()async{

    String url = 'https://api.instantwebtools.net/v1/passenger?page=4&size= '+addData.toString()+'';

    var response =  await http.get(url);
    try{
      if(response.statusCode == 200){
        final user = userFromJson(response.body);
        setState(() {
          _user = user;
          isLoading = false;
        });
      }
    }catch(e){
      print(e);
    }
    return _user;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    scrollController.addListener(() {
      print(scrollController.position.pixels);
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        setState(() {
          addData = addData + 2;
        });
        fetchData();
      }
    });
    print(_user);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RowWidget(
                  iconData: Icons.home,
                  title: 'Real Estate',
                  color: Colors.pink,
                ),
                RowWidget(
                  iconData: Icons.car_repair,
                  title: 'Cars',
                  color: Colors.blue,
                ),
                RowWidget(
                  iconData: Icons.tv,
                  title: 'Electronics',
                  color: Colors.tealAccent,
                ),
                RowWidget(
                  iconData: Icons.mobile_screen_share_rounded,
                  title: 'Cars',
                  color: Colors.purple,
                ),
                RowWidget(
                  iconData: Icons.menu,
                  title: 'Cars',
                  color: Colors.orange,
                ),
              ],
            ),
            Expanded(
              child: _user==null?  Container(
                height: isLoading ? 50.0 : 0,
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              ): GridView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _user.data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                  ),
                  itemBuilder: (context,index){
                    return GridWidget(
                      airlineName: _user.data[index].airline.name,
                      airlineHeadquarter: _user.data[index].airline.headQuaters,
                      airlineCountry: _user.data[index].airline.country,
                      image:NetworkImage(_user.data[index].airline.logo),
                    );
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {

  final IconData iconData;
  final String title;
  final Color color;

  const RowWidget({Key key, this.iconData, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(iconData,),
          ),
          Text(title)
        ],
      ),
    );
  }
}

class GridWidget extends StatelessWidget {

  final String airlineName;
  final String airlineCountry;
  final String airlineHeadquarter;
  final NetworkImage image;

  const GridWidget({Key key, this.airlineName, this.airlineCountry, this.airlineHeadquarter, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          // height: 300,
          width: 250,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: image,
                          fit: BoxFit.fitWidth
                      ),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                      color: Colors.grey
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10,bottom: 10),
                    height: 100,
                    color: Colors.white54,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('\$129,000',style: TextStyle(fontSize: 18,color: Colors.red),),
                        Text(airlineName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                        Text(airlineHeadquarter,overflow: TextOverflow.fade),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.location_on,size: 14,),
                              Text(airlineCountry,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            height: 25,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.tealAccent
            ),
            child: Center(
              child: Text('Featured',
                style: TextStyle(fontWeight: FontWeight.w500),),
            ),
          ),
        ),
        Positioned(
            right: 10,
            top: 10,
            child: Icon(Icons.favorite_outlined,color: Colors.white,))
      ],
    );
  }
}