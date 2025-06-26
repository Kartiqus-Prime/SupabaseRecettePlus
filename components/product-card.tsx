import Image from "next/image"
import { Star, ShoppingCart } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import type { Product } from "@/lib/types"

interface ProductCardProps {
  product: Product
}

export default function ProductCard({ product }: ProductCardProps) {
  return (
    <Card className="group hover:shadow-lg transition-shadow duration-300">
      <CardContent className="p-0">
        <div className="relative overflow-hidden">
          <Image
            src={product.image || "/placeholder.svg"}
            alt={product.name}
            width={300}
            height={300}
            className="w-full h-48 object-cover group-hover:scale-105 transition-transform duration-300"
          />
          {product.originalPrice && (
            <Badge className="absolute top-2 left-2 bg-red-500">
              -{Math.round(((product.originalPrice - product.price) / product.originalPrice) * 100)}%
            </Badge>
          )}
          {!product.inStock && (
            <Badge variant="secondary" className="absolute top-2 right-2">
              Rupture de stock
            </Badge>
          )}
        </div>

        <div className="p-4">
          <h3 className="font-semibold text-lg mb-2 line-clamp-2">{product.name}</h3>
          <p className="text-gray-600 text-sm mb-3 line-clamp-2">{product.description}</p>

          <div className="flex items-center mb-3">
            <div className="flex items-center">
              {[...Array(5)].map((_, i) => (
                <Star
                  key={i}
                  className={`h-4 w-4 ${
                    i < Math.floor(product.rating) ? "text-yellow-400 fill-current" : "text-gray-300"
                  }`}
                />
              ))}
            </div>
            <span className="text-sm text-gray-600 ml-2">
              {product.rating} ({product.reviews} avis)
            </span>
          </div>

          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-2">
              <span className="text-xl font-bold text-blue-600">{product.price}€</span>
              {product.originalPrice && (
                <span className="text-sm text-gray-500 line-through">{product.originalPrice}€</span>
              )}
            </div>

            <Button size="sm" disabled={!product.inStock} className="flex items-center space-x-1">
              <ShoppingCart className="h-4 w-4" />
              <span>Ajouter</span>
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
