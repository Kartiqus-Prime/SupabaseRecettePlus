export interface Product {
  id: number
  name: string
  price: number
  originalPrice?: number
  image: string
  category: string
  rating: number
  reviews: number
  description: string
  inStock: boolean
}

export interface Category {
  id: string
  name: string
  image: string
  productCount: number
}
