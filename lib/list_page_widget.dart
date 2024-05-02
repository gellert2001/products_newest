import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:products_newest/ProductType.dart';
import 'package:products_newest/Product_Repository.dart';
import 'package:products_newest/ProductModel.dart';
import 'package:products_newest/list_page_widget.dart';

import 'package:products_newest/VoteBloc.dart';
import 'package:products_newest/VoteCounter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPageWidget extends StatefulWidget{
  const ListPageWidget(Key? key) : super(key : key);

  @override
  State<StatefulWidget> createState() => _ListPageWidgetState();
}

class _ListPageWidgetState extends State<ListPageWidget> {
  final productRepository = ProductRepository();
  Future<List<Product>>? listreqProduct;
  bool isTopUpvotedListVisible = false;

  final productTypeRepository = ProductTypeRepository();
  Future<List<ProductType>>? listreqProductType;
//TODO
  ProductType? selectedCategory;
  @override
  void initState(){
    listreqProduct = productRepository.getProducts();
    listreqProductType = productTypeRepository.getProductTypes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<List<ProductType>>(
            future: listreqProductType,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final categories = snapshot.data!;

                return DropdownButton<ProductType>(
                  value: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  items: categories.map((category) {
                    return DropdownMenuItem<ProductType>(
                      value: category, // ProductType.name beállítása értékként
                      child: Text(category.name), // ProductType.name beállítása címkének
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          InkWell(
            onTap: () {
              setState(() {
                isTopUpvotedListVisible = !isTopUpvotedListVisible;
              });
            },
            child: const Padding(
              padding:  EdgeInsets.all(8.0),
              child: Text(
                'Top Upvoted Products',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Visibility(
            visible: isTopUpvotedListVisible,
            child: Expanded(
              flex: 1,
              child: Hero(
                tag: 'top_upvoted_list',
                child: TopUpvotedProductsList(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: listreqProduct,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final products = snapshot.data!;
                  // Filter products based on selected category
                  final filteredProducts = selectedCategory == null
                      ? products
                      : products.where((product) => product.category == selectedCategory!.name);
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Hero(
                          tag: product.id, // Azonosító a Hero animációhoz
                          child: GridTile(
                            footer: GridTileBar(
                              title: Text(
                                  product.title,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            child: Image.network(
                              product.thumbnail,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}

/*
class TopUpvotedProductsList extends StatelessWidget {
  final ProductRepository productRepository = ProductRepository();

  TopUpvotedProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productRepository.getProducts(), // Termékek lekérése
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Adatok sikeresen lekérve
          List<Product> products = snapshot.data!;

          // Termékek rendezése upvote-ok szerint csökkenő sorrendben
          products.sort((a, b) => b.voteBloc.votecounter.upvote.compareTo(a.voteBloc.votecounter.upvote));

          // A rendezett termékek megjelenítése
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Top Upvoted Products:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: Image.network(product.thumbnail),
                    title: Text(product.title),
                    subtitle: Text('Upvotes: ${product.voteBloc.votecounter.upvote}'),
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // Hiba esetén
          return Text('Error: ${snapshot.error}');
        } else {
          // Adatok betöltése folyamatban
          return const CircularProgressIndicator();
        }
      },
    );
  }
}


class TopUpvotedProductsList extends StatelessWidget {
  final ProductRepository productRepository = ProductRepository();

  TopUpvotedProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Upvoted Products:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          FutureBuilder<List<Product>>(
            future: productRepository.getProducts(), // Termékek lekérése
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Adatok sikeresen lekérve
                List<Product> products = snapshot.data!;

                // Termékek rendezése upvote-ok szerint csökkenő sorrendben
                products.sort((a, b) => b.voteBloc.votecounter.upvote.compareTo(a.voteBloc.votecounter.upvote));

                // A rendezett termékek megjelenítése
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      leading: Image.network(product.thumbnail),
                      title: Text(product.title),
                      subtitle: Text('Upvotes: ${product.voteBloc.votecounter.upvote}'),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Hiba esetén
                return Text('Error: ${snapshot.error}');
              } else {
                // Adatok betöltése folyamatban
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
*/
class TopUpvotedProductsList extends StatelessWidget {
  final ProductRepository productRepository = ProductRepository();

  TopUpvotedProductsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const  EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Upvoted Products:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: SingleChildScrollView( // Add a SingleChildScrollView here
              child: FutureBuilder<List<Product>>(
                future: productRepository.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> products = snapshot.data!;
                    products.sort((a, b) => b.voteBloc.votecounter.upvote.compareTo(a.voteBloc.votecounter.upvote));
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          leading: Image.network(product.thumbnail),
                          title: Text(product.title),
                          subtitle: Text('Upvotes: ${product.voteBloc.votecounter.upvote}'),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ProductDetailScreen extends StatefulWidget {

  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();

}

class _ProductDetailScreenState extends State<ProductDetailScreen>  {
  late VoteBloc _voteBloc;

  @override
  void initState() {
    super.initState();
    _voteBloc = VoteBloc(widget.product.voteBloc.votecounter);
    _voteBloc.initializeVoteCounter(widget.product.voteBloc.votecounter);
  }
  @override
  void dispose() {
    _voteBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                  child: Hero(
                    tag: widget.product.id, // Azonosító a Hero animációhoz
                    child: Image.network(
                      widget.product.images[0],
                      fit: BoxFit.contain,
                      height: null,
                    ),
                  )
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Ár: ${widget.product.price} Ft',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.product.description,
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up),
                        onPressed: () {
                          _voteBloc.increaseUpvote();
                        },
                      ),
                      StreamBuilder<VoteCounter>(
                        stream: _voteBloc.voteStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('${snapshot.data!.upvote}');
                          } else {
                            return const Text('0');
                          }
                        },
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.thumb_down),
                        onPressed: () {
                          _voteBloc.increaseDownvote();
                        },
                      ),
                      StreamBuilder<VoteCounter>(
                        stream: _voteBloc.voteStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('${snapshot.data!.downvote}');
                          } else {
                            return const Text('0');
                          }
                        },
                      ),
                    ],
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


class ListItem extends StatelessWidget {
  final Product item;

  const ListItem(this.item, {required super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return Card(
        child:
        SizedBox(
          height: 80,
          child:
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Image(
                  image: NetworkImage(item.thumbnail),
                  fit: BoxFit.fitWidth,
                )
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${item.brand} - ${item.price} - ${item.rating}")
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(right: 8.0))
            ],
          ),
        ),
      ); //en
    }catch(error){
      if (kDebugMode)
      {
        print(error);

      }
      return const Card();
    }// d of card
  }
}