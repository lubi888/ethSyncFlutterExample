// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'dart:convert';     // show UTF8;

class PestoDemo extends StatelessWidget {
  const PestoDemo({ Key key }) : super(key: key);

  static const String routeName = '/pesto';

  @override
  Widget build(BuildContext context) => new PestoHome();
}

//const String _kSmallLogoImage = 'packages/flutter_gallery_assets/pesto/logo_small.png';
//const String _kMediumLogoImage = 'packages/flutter_gallery_assets/pesto/logo_medium.png';
const String _kSmallLogoImage = 'assets/logo.png';
const String _kMediumLogoImage = 'assets/logo.png';

const double _kAppBarHeight = 128.0;
const double _kFabHalfSize = 28.0;  // TODO(mpcomplete): needs to adapt to screen size
const double _kRecipePageMaxWidth = 500.0;
const String hiero = "\U{00013004}";          //try these new unicode
const String u = "\\U(00013000)";
//const String p = '\u00013000';   //          00013000';
const String uni = '\u1300';

final Set<Recipe> _favoriteRecipes = new Set<Recipe>();

final ThemeData _kTheme = new ThemeData(
  brightness: Brightness.dark, //.light,
  primarySwatch: Colors.red,     //teal
  accentColor: Colors.yellowAccent,  //redAccent,  //amber
);

class PestoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const RecipeGridPage(recipes: kPestoRecipes);
  }
}

class PestoFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new RecipeGridPage(recipes: _favoriteRecipes.toList());
  }
}

class PestoStyle extends TextStyle {
  const PestoStyle({
    double fontSize: 12.0,
    FontWeight fontWeight,
    Color color: Colors.redAccent,        //.black87,
    double letterSpacing,
    double height,
  }) : super(
    inherit: false,
    color: color,
    fontFamily: 'Raleway',
    fontSize: fontSize,
    fontWeight: fontWeight,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: letterSpacing,
    height: height,
  );
}

// Displays a grid of recipe cards.
class RecipeGridPage extends StatefulWidget {
  const RecipeGridPage({ Key key, this.recipes }) : super(key: key);

  final List<Recipe> recipes;

  @override
  _RecipeGridPageState createState() => new _RecipeGridPageState();
}

class _RecipeGridPageState extends State<RecipeGridPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Theme(
      data: _kTheme.copyWith(platform: Theme.of(context).platform),
      child: new Scaffold(
        key: scaffoldKey,
        floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.android),         //.edit),
          onPressed: () {
            scaffoldKey.currentState.showSnackBar(const SnackBar(
              //does accept newline
              content: const Text('now turn this tapNot4 supported.t4 supported.\ni have abasdfs no idea how to do that ')             //('Not supported.'),
            ));
          },
        ),
        body: new CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context, statusBarHeight),
            _buildBody(context, statusBarHeight),
          ],
        ),
      )
    );
  }

  Widget _buildAppBar(BuildContext context, double statusBarHeight) {
    return new SliverAppBar(
      pinned: true,
      expandedHeight: _kAppBarHeight,
      actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.search),          //  .search),   //change to android , any material
          tooltip: 'SearchAndroid',
          onPressed: () {
            scaffoldKey.currentState.showSnackBar(const SnackBar(
              content: const Text('Not at al6l\n popup supported. $hiero '),
            ));
          },
        ),
      ],
      flexibleSpace: new LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size size = constraints.biggest;
          final double appBarHeight = size.height - statusBarHeight;
          final double t = (appBarHeight - kToolbarHeight) / (_kAppBarHeight - kToolbarHeight);
          final double extraPadding = new Tween<double>(begin: 10.0, end: 24.0).lerp(t);
          final double logoHeight = appBarHeight - 1.5 * extraPadding;
          return new Padding(
            padding: new EdgeInsets.only(
              top: statusBarHeight + 0.5 * extraPadding,
              bottom: extraPadding,
            ),
            child: new Center(
              child: new PestoLogo(height: logoHeight, t: t.clamp(0.0, 1.0))
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, double statusBarHeight) {
    final EdgeInsets padding = const EdgeInsets.all(8.0);
    return new SliverPadding(
      padding: padding,
      sliver: new SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _kRecipePageMaxWidth,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final Recipe recipe = widget.recipes[index];
            return new RecipeCard(
              recipe: recipe,
              onTap: () { showRecipePage(context, recipe); },
            );
          },
          childCount: widget.recipes.length,
        ),
      ),
    );
  }

  void showFavoritesPage(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<Null>(
      settings: const RouteSettings(name: "/pesto/favorites"),
      builder: (BuildContext context) => new PestoFavorites(),
    ));
  }

  void showRecipePage(BuildContext context, Recipe recipe) {
    Navigator.push(context, new MaterialPageRoute<Null>(
      settings: const RouteSettings(name: "/pesto/recipe"),
      builder: (BuildContext context) {
        return new Theme(
          data: _kTheme.copyWith(platform: Theme.of(context).platform),
          child: new RecipePage(recipe: recipe),
        );
      },
    ));
  }
}

class PestoLogo extends StatefulWidget {
  const PestoLogo({this.height, this.t});

  final double height;
  final double t;

  @override
  _PestoLogoState createState() => new _PestoLogoState();
}

class _PestoLogoState extends State<PestoLogo> {
  // Native sizes for logo and its image/text components.
  static const double kLogoHeight = 162.0;
  static const double kLogoWidth = 220.0;
  static const double kImageHeight = 108.0;
  static const double kTextHeight = 48.0;
  //header color
  final TextStyle titleStyle = const PestoStyle(fontSize: kTextHeight, fontWeight: FontWeight.w900, color: Colors.redAccent, letterSpacing: 3.0);
  final RectTween _textRectTween = new RectTween(
    begin: new Rect.fromLTWH(0.0, kLogoHeight, kLogoWidth, kTextHeight),
    end: new Rect.fromLTWH(0.0, kImageHeight, kLogoWidth, kTextHeight)
  );
  final Curve _textOpacity = const Interval(0.4, 1.0, curve: Curves.easeInOut);
  final RectTween _imageRectTween = new RectTween(
    begin: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kLogoHeight),
    end: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kImageHeight),
  );

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.identity()..scale(widget.height / kLogoHeight),
      alignment: FractionalOffset.topCenter,
      child: new SizedBox(
        width: kLogoWidth,
        child: new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            new Positioned.fromRect(
              rect: _imageRectTween.lerp(widget.t),
              child: new Image.asset(_kSmallLogoImage, fit: BoxFit.contain),
            ),
            new Positioned.fromRect(
              rect: _textRectTween.lerp(widget.t),
              child: new Opacity(
                opacity: _textOpacity.transform(widget.t),
                child: new Text('ethSync', style: titleStyle, textAlign: TextAlign.center),    //head bar under graph basil leaf
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A card with the recipe's image, author, and title.
class RecipeCard extends StatelessWidget {
  final TextStyle titleStyle = const PestoStyle(fontSize: 24.0, fontWeight: FontWeight.w600);
  final TextStyle authorStyle = const PestoStyle(fontWeight: FontWeight.w500, color: Colors.blue);    //Colors.black54);

  const RecipeCard({ Key key, this.recipe, this.onTap }) : super(key: key);

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Hero(
              tag: recipe.imagePath,
              child: new Image.asset(recipe.imagePath, fit: BoxFit.contain)
            ),
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Image.asset(
                      recipe.ingredientsImagePath,
                      width: 48.0,
                      height: 48.0,
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(recipe.name, style: titleStyle, softWrap: false, overflow: TextOverflow.ellipsis),
                        new Text(recipe.author, style: authorStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Displays one recipe. Includes the recipe sheet with a background image.
class RecipePage extends StatefulWidget {
  const RecipePage({ Key key, this.recipe }) : super(key: key);

  final Recipe recipe;

  @override
  _RecipePageState createState() => new _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextStyle menuItemStyle = const PestoStyle(fontSize: 15.0, color: Colors.green, height: 24.0/15.0);           //Colors.black54, height: 24.0/15.0);             //Colors.black54, height: 24.0/15.0);
// top r dropdown text colours    popupmenue item ?
  double _getAppBarHeight(BuildContext context) => MediaQuery.of(context).size.height * 0.3;

  @override
  Widget build(BuildContext context) {
    // The full page content with the recipe's image behind it. This
    // adjusts based on the size of the screen. If the recipe sheet touches
    // the edge of the screen, use a slightly different layout.
    final double appBarHeight = _getAppBarHeight(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool fullWidth = (screenSize.width < _kRecipePageMaxWidth);
    final bool isFavorite = _favoriteRecipes.contains(widget.recipe);
    return new Scaffold(
      key: _scaffoldKey,
      body: new Stack(
        children: <Widget>[
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            height: appBarHeight + _kFabHalfSize,
            child: new Hero(
              tag: widget.recipe.imagePath,
              child: new Image.asset(
                widget.recipe.imagePath,
                fit: fullWidth ? BoxFit.fitWidth : BoxFit.cover,
              ),
            ),
          ),
          new CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                expandedHeight: appBarHeight - _kFabHalfSize,
                backgroundColor: Colors.transparent,
                actions: <Widget>[
                  new PopupMenuButton<String>(
                    onSelected: (String item) {},
                    itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                      _buildMenuItem(Icons.share, 'Tweet recipe'),
                      _buildMenuItem(Icons.email, 'Email recipe'),
                      _buildMenuItem(Icons.message, 'Message recipe'),
                      _buildMenuItem(Icons.people, 'Share on Facebook'),
                    ],
                  ),
                ],
                flexibleSpace: new FlexibleSpaceBar(
                  background: new DecoratedBox(
                    decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: const FractionalOffset(0.5, 0.0),
                        end: const FractionalOffset(0.5, 0.40),
                        colors: <Color>[const Color(0x60000000), const Color(0x00000000)],
                      ),
                    ),
                  ),
                ),
              ),
              new SliverToBoxAdapter(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(top: _kFabHalfSize),
                      width: fullWidth ? null : _kRecipePageMaxWidth,
                      child: new RecipeSheet(recipe: widget.recipe),
                    ),
                    new Positioned(
                      right: 16.0,
                      child: new FloatingActionButton(
                        child: new Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                        onPressed: _toggleFavorite,
                      ),
                    ),
                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(IconData icon, String label) {
    return new PopupMenuItem<String>(
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: new Icon(icon, color: Colors.black54)
          ),
          new Text(label, style: menuItemStyle),
        ],
      ),
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (_favoriteRecipes.contains(widget.recipe))
        _favoriteRecipes.remove(widget.recipe);
      else
        _favoriteRecipes.add(widget.recipe);
    });
  }
}

/// Displays the recipe's name and instructions.
/// main body text colour
class RecipeSheet extends StatelessWidget {
  final TextStyle titleStyle = const PestoStyle(fontSize: 34.0);
  final TextStyle descriptionStyle = const PestoStyle(fontSize: 15.0, color: Colors.blue, height: 24.0/15.0);
  final TextStyle itemStyle = const PestoStyle(fontSize: 15.0, color: Colors.yellowAccent, height: 24.0/15.0);              // height: 24.0/15.0);
  final TextStyle itemAmountStyle = new PestoStyle(fontSize: 15.0, color: Colors.green, height: 24.0/15.0);   //color: _kTheme.primaryColor, height
  final TextStyle headingStyle = const PestoStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.orangeAccent, height: 24.0/15.0);              //height: 24.0/15.0);

  RecipeSheet({ Key key, this.recipe }) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: new Table(
          columnWidths: <int, TableColumnWidth>{
            0: const FixedColumnWidth(64.0)
          },
          children: <TableRow>[
            new TableRow(
              children: <Widget>[
                new TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: new Image.asset(
                    recipe.ingredientsImagePath,
                    width: 32.0,
                    height: 32.0,
                    alignment: FractionalOffset.centerLeft,
                    fit: BoxFit.scaleDown
                  )
                ),
                new TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: new Text(recipe.name, style: titleStyle)
                ),
              ]
            ),
            new TableRow(
              children: <Widget>[
                const SizedBox(),
                new Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                  child: new Text(recipe.description, style: descriptionStyle)
                ),
              ]
            ),
            new TableRow(
              children: <Widget>[
                const SizedBox(),
                new Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 4.0),
                  child: new Text('Ingredients', style: headingStyle)
                ),
              ]
            ),
          ]..addAll(recipe.ingredients.map(
            (RecipeIngredient ingredient) {
              return _buildItemRow(ingredient.amount, ingredient.description);
            }
          ))..add(
            new TableRow(
              children: <Widget>[
                const SizedBox(),
                new Padding(
                  padding: const EdgeInsets.only(top: 24.0, bottom: 4.0),
                  child: new Text('Steps', style: headingStyle)
                ),
              ]
            )
          )..addAll(recipe.steps.map(
            (RecipeStep step) {
              return _buildItemRow(step.duration ?? '', step.description);
            }
          )),
        ),
      ),
    );
  }

  TableRow _buildItemRow(String left, String right) {
    return new TableRow(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(left, style: itemAmountStyle),
        ),
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(right, style: itemStyle),
        ),
      ],
    );
  }
}

class Recipe {
  const Recipe({
    this.name,
    this.author,
    this.description,
    this.imagePath,
    this.ingredientsImagePath,
    this.ingredients,
    this.steps
  });

  final String name;
  final String author;
  final String description;
  final String imagePath;
  final String ingredientsImagePath;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

}

class RecipeIngredient {
  const RecipeIngredient({this.amount, this.description});

  final String amount;
  final String description;
}

class RecipeStep {
  const RecipeStep({this.duration, this.description});

  final String duration;
  final String description;
}

const List<Recipe> kPestoRecipes = const <Recipe>[
  const Recipe(
    name: 'ethSync blockchain',
    author: 'linUbi',
    ingredientsImagePath: 'assets/ethBullet.png',             // 'packages/flutter_gallery_assets/pesto/quick.png',
    description: 'This is were all the desc goes.\nsooooo many things to do.',        //'Bask in greens this season by trying this delightful take on traditional bruschetta. Top with a dollop of homemade pesto, and season with freshly ground sea salt and pepper.',
    imagePath: 'assets/ethSync.jpg',            //'packages/flutter_gallery_assets/pesto/image1.jpg',
    ingredients: const<RecipeIngredient>[
// const RecipeIngredient(amount: '1 tsp', description: 'Salt'),
//      const RecipeIngredient(amount: '2 tsp', description: 'Lemon'),
//      const RecipeIngredient(amount: '4 cups', description: 'Chicken stock'),
//      const RecipeIngredient(amount: 'RAM', description: 'Import, Check'),
      const RecipeIngredient(amount: 'ROM', description: 'Long storage. HDD, SD drive'),
      const RecipeIngredient(amount: 'Net', description: 'makes differen between doing this in days and in hours'),
      const RecipeIngredient(amount: 'Time', description: 'everything u have '),
      const RecipeIngredient(amount: 'Luck', description: 'Salt pinch'),
    ],
    steps: const<RecipeStep>[
      const RecipeStep(duration: 'whatever uw want', description: 'coffee, tea, etc.'),
      const RecipeStep(duration: '6hrs - 6 days', description: 'synchronizing'),
    ],


//      const RecipeIngredient(amount: '6 pieces', description: 'Mozzarella cheese'),
//      const RecipeIngredient(amount: '6 pieces', description: 'Toasts'),
//      const RecipeIngredient(amount: '⅔ cup', description: 'Homemade pesto'),
//      const RecipeIngredient(amount: '1tbsp', description: 'Freshly ground pepper'),
//      const RecipeIngredient(amount: '1 tsp', description: 'Salt'),
//    ],
//    steps: const<RecipeStep>[
//      const RecipeStep(description: 'Put in oven'),
//      const RecipeStep(duration: '45 min', description: 'Cook'),
//    ],
  ),
  const Recipe(
    name: 'eth CLI',
    author: 'lubi_dev',
    ingredientsImagePath: 'assets/ethBullet.png',
    description: 'knowledge impart\nsimple clear concise', //cooking with these South American purple potatoes is a treat. Boil, mash, bake, or roast them. For taste cook with chicken stock, and a dash of extra virgin olive oil.',
    imagePath: 'assets/wallpaper-homestead.jpg',
    ingredients: const<RecipeIngredient>[
      const RecipeIngredient(amount: 'xx', description: 'get set for ethSync\n...'),
//      const RecipeIngredient(amount: '1 tsp', description: 'Salt'),
//      const RecipeIngredient(amount: '2 tsp', description: 'Lemon'),
//      const RecipeIngredient(amount: '4 cups', description: 'Chicken stock'),
//      const RecipeIngredient(amount: '1 drop', description: 'love and attn')
    ],
    steps: const<RecipeStep>[
      const RecipeStep(duration: 'type \n \"xx\"', description: 'different approaches.\nadd info\n $uni'),           //'3 min', description: 'Stir'),
      const RecipeStep(duration: '45 min\n \u1300\n $u \n $uni', description: 'nothing here but knowhow'),   //$p
    ],



//    name: 'Rustic purple mash',
//    author: 'Trevor Hansen',
//    ingredientsImagePath: 'packages/flutter_gallery_assets/pesto/veggie.png',
//    description: 'Abundant in color, and healthy, delicious goodness, cooking with these South American purple potatoes is a treat. Boil, mash, bake, or roast them. For taste cook with chicken stock, and a dash of extra virgin olive oil.',
//    imagePath: 'packages/flutter_gallery_assets/pesto/image2.jpg',
//    ingredients: const<RecipeIngredient>[
//      const RecipeIngredient(amount: '2 lbs', description: 'Purple potatoes, skin on'),
//      const RecipeIngredient(amount: '1 tsp', description: 'Salt'),
//      const RecipeIngredient(amount: '2 tsp', description: 'Lemon'),
//      const RecipeIngredient(amount: '4 cups', description: 'Chicken stock'),
//      const RecipeIngredient(amount: '1tbsp', description: 'Extra virgin olive oil')
//    ],
//    steps: const<RecipeStep>[
//      const RecipeStep(duration: '3 min', description: 'Stir'),
//      const RecipeStep(duration: '45 min', description: 'Cook'),
//    ],
  ),
  const Recipe(
    name: 'ethCliSync Teminator',
    author: 'lubi',
    ingredientsImagePath: 'assets/ethBullet.png',
    description: 'talk to me about this one\nglorious way to put screen.',
    imagePath: 'assets/ethGreenHelp.png',
    ingredients: const<RecipeIngredient>[
      const RecipeIngredient(amount: 'linux terminal', description: 'CLInterface'),
      const RecipeIngredient(amount: 'type', description: 'cmnds'),
//      const RecipeIngredient(amount: '⅔ cup', description: 'Shaved parmesan cheese'),
//      const RecipeIngredient(amount: '1tbsp', description: 'Extra virgin olive oil'),
//      const RecipeIngredient(amount: '1 tsp', description: 'Lemon juice'),
//      const RecipeIngredient(amount: '1/2 cup', description: 'Sun dried tomatoes'),
    ],
    steps: const<RecipeStep>[
      const RecipeStep(duration: '30 min', description: 'boot P2P'),
      const RecipeStep(duration: '60 min', description: 'geth'),
    ],
  ),
  const Recipe(
    name: 'Cli Further tech',
    author: 'lubi',
    ingredientsImagePath: 'assets/logoCli.png',
    description: 'Robust cuts of portuguese sausage add layers of flavour. Bake or fry until sausages are slightly browned and with a crispy skin. Serve warm and with cuts of pineapple for a delightful mix of sweet and savory flavour. This is the perfect dish after a swim in the sea.',
    imagePath: 'assets/gethTerm.png',
    ingredients: const<RecipeIngredient>[
      const RecipeIngredient(amount: 'linux terminal', description: 'CLInterface'),
      const RecipeIngredient(amount: 'type', description: 'cmnds'),
    ],
    steps: const<RecipeStep>[
      const RecipeStep(duration: '30 min', description: 'boot P2P'),
      const RecipeStep(duration: '60 min', description: 'geth'),
    ],
  ),
  const Recipe(
    //keep checking Unicode
    name: 'Lets Roast \u1300',
    author: 'terminator',
    ingredientsImagePath: 'assets/logoCli.png',
    description: 'Clear writing instructions\nshort and poignant.\n',
    imagePath: 'assets/devcon1.png',   //green clear , on blk
    ingredients: const<RecipeIngredient>[
      const RecipeIngredient(amount: 'linux terminal', description: 'CLInterface'),
      const RecipeIngredient(amount: 'type', description: 'cmnds'),
    ],
    steps: const<RecipeStep>[
      const RecipeStep(duration: '30 min', description: 'boot P2P'),
      const RecipeStep(duration: '60 min', description: 'geth'),
    ],
  ),
  const Recipe(
    name: 'du prosperity',
    author: 'ethSync',
    ingredientsImagePath: 'assets/duIcon.png',
    description: 'This dish is a terrific pairing to almost any main. Bonus- it’s quick, easy to make, and turns even the simplest of dishes into a delicacy. Sweet coconut cream will leave your mouth watering, with yummy caramelized  flecks of rice adding an extra bit of taste. Fluff with fork before serving for best results.',
    imagePath: 'assets/bleachBitSwap.png',   //green clear , on blk
    ingredients: const<RecipeIngredient>[
      const RecipeIngredient(amount: 'linux terminal', description: 'CLInterface'),
      const RecipeIngredient(amount: 'type', description: 'cmnds'),
    ],
    steps: const<RecipeStep>[
      const RecipeStep(duration: '30 min', description: 'boot P2P'),
      const RecipeStep(duration: '60 min', description: 'geth'),
    ],
  ),
];
