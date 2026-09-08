class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  const Product(this.name, this.description, this.price, this.imageUrl);
}

final List<Product> dummyProducts = [
  Product(
    'Mercedes-Benz S-Class',
    'Flagship luxury sedan with cutting-edge tech and a plush cabin',
    15000000.0,
    'https://images.unsplash.com/photo-1610099610040-ab19f3a5ec35?auto=format&fit=crop&w=400&q=80',
  ),
  Product(
    'Rolls-Royce Phantom',
    'The pinnacle of hand-built luxury and effortless power',
    59000000.0,
    'https://images.unsplash.com/photo-1740098160485-d098fbf42814?auto=format&fit=crop&w=400&q=80',
  ),
  Product(
    'Lamborghini Huracan',
    'Italian V10 supercar built for speed and drama',
    33500000.0,
    'https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&w=400&q=80',
  ),
  Product(
    'Ferrari',
    'Iconic Italian sports car with racing heritage',
    32000000.0,
    'https://images.unsplash.com/photo-1583121274602-3e2820c69888?auto=format&fit=crop&w=400&q=80',
  ),
  Product(
    'Bentley Continental GT',
    'British grand tourer blending handcrafted luxury with performance',
    28000000.0,
    'https://images.unsplash.com/photo-1774203388195-2c4bb159606a?auto=format&fit=crop&w=400&q=80',
  ),
  Product(
    'McLaren 720S',
    'British hypercar with a carbon fiber chassis and track-ready handling',
    38500000.0,
    'https://images.unsplash.com/photo-1577473403731-a36ec9087f44?auto=format&fit=crop&w=400&q=80',
  ),
];