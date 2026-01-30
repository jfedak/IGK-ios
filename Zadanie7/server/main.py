from fastapi import FastAPI
from pydantic import BaseModel
from datetime import date

app = FastAPI()

categories = [
  {
    "id": 1,
    "name": "Shoes",
  },
  {
    "id": 2,
    "name": "T-shirts",
  },
  {
    "id": 3,
    "name": "Hoodies",
  },
  {
    "id": 4,
    "name": "Jackets",
  }
]

products = [
  {
    "id": 1,
    "category_id": 1,
    "name": "CloudRunner Elite",
    "price": 129.99,
    "description": "Lightweight running shoes designed for maximum energy return and marathon endurance."
  },
  {
    "id": 2,
    "category_id": 1,
    "name": "Urban Trekker Boots",
    "price": 145.00,
    "description": "Durable leather boots with slip-resistant soles, perfect for city streets and light trails."
  },
  {
    "id": 3,
    "category_id": 1,
    "name": "Canvas Classic Lo",
    "price": 45.50,
    "description": "Timeless low-top canvas sneakers suitable for everyday casual wear in any season."
  },
  {
    "id": 4,
    "category_id": 2,
    "name": "Vintage Logo Tee",
    "price": 24.99,
    "description": "Soft organic cotton blend featuring a distressed retro-style brand graphic."
  },
  {
    "id": 5,
    "category_id": 2,
    "name": "Pro-Active Fit",
    "price": 35.00,
    "description": "Moisture-wicking athletic top designed to keep you cool during intense workouts."
  },
  {
    "id": 6,
    "category_id": 2,
    "name": "Essential Heavyweight",
    "price": 18.00,
    "description": "A premium heavyweight cotton t-shirt with a boxy fit that goes with everything."
  },
  {
    "id": 7,
    "category_id": 3, 
    "name": "Cozy Fleece Pullover",
    "price": 55.00,
    "description": "Oversized fit hoodie lined with brushed fleece and a spacious kangaroo pocket."
  },
  {
    "id": 8,
    "category_id": 3,
    "name": "Streetwear Zip-Up",
    "price": 72.50,
    "description": "Modern slim-fit zip hoodie featuring reinforced stitching and metal hardware."
  },
  {
    "id": 9,
    "category_id": 3,
    "name": "Tech-Knit Hoodie",
    "price": 85.00,
    "description": "Breathable and stretchable hoodie designed specifically for active lifestyles and travel."
  },
  {
    "id": 10,
    "category_id": 4,
    "name": "Midnight Bomber",
    "price": 110.00,
    "description": "Classic silhouette bomber jacket featuring a water-resistant nylon shell and ribbed cuffs."
  },
  {
    "id": 11,
    "category_id": 4,
    "name": "Alpine Windbreaker",
    "price": 95.00,
    "description": "Ultra-lightweight shell jacket that packs down into its own pocket for easy storage."
  },
  {
    "id": 12,
    "category_id": 4,
    "name": "Denim Sherpa Coat",
    "price": 130.00,
    "description": "Rugged indigo denim jacket lined with warm faux sherpa for cooler autumn days."
  }
]

orders = [
    {
        "order_id": 1,
        "date": "2025-12-29",
        "products": [1, 4, 7],
        "quantity": [1, 2, 1],
        "total_price": 234.99,
        "status": "shipped"
    },
    {
        "order_id": 2,
        "date": "2025-12-30",
        "products": [10],
        "quantity": [3],
        "total_price": 330.00,
        "status": "processing"
    },
    {
        "order_id": 3,
        "date": "2026-01-02",
        "products": [2, 5],
        "quantity": [1, 1],
        "total_price": 180.00,
        "status": "delivered"
    }
]

@app.get("/products")
def get_data(category: str = None):
    if category:
        filtered_products = [product for product in products if product["category_id"] == int(category)]
        return filtered_products
    return products

@app.get("/categories")
def get_categories():
    return categories

class Product(BaseModel):
    category_id: int
    name: str
    price: float
    description: str

@app.post("/add_product")
def add_product(product: Product):
    new_product = {
        "id": len(products) + 1,
        "category_id": product.category_id,
        "name": product.name,
        "price": product.price,
        "description": product.description
    }
    products.append(new_product)
    return {"status": "Product added successfully", "id": new_product["id"]}

@app.get("/orders")
def get_orders():
    return orders

class Order(BaseModel):
    products: list[int]
    quantity: list[int]
    card_number: str
    expiry_date: str
    cvv: str

@app.post("/add_order")
def add_order(order: Order):
    # mocking payment
    print(order.card_number, order.expiry_date, order.cvv)

    total_price = sum(products[prod_id - 1]["price"] * qty for prod_id, qty in zip(order.products, order.quantity))
    total_price = round(total_price, 2)
    new_order = {
        "order_id": len(orders) + 1,
        "date": str(date.today()),
        "products": order.products,
        "quantity": order.quantity,
        "total_price": total_price,
        "status": "processing"
    }
    orders.append(new_order)
    return {
        "order_id": new_order["order_id"], 
        "date": new_order["date"],
        "total_price": new_order["total_price"],
        "status": new_order["status"]
    }

# print(date.today())
