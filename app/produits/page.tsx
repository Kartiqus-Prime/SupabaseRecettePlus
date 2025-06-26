"use client"

import { useState } from "react"
import ProductCard from "@/components/product-card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Badge } from "@/components/ui/badge"
import { Search, Filter } from "lucide-react"
import { products, categories } from "@/lib/data"

export default function ProductsPage() {
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedCategory, setSelectedCategory] = useState("all")
  const [sortBy, setSortBy] = useState("name")

  const filteredProducts = products
    .filter((product) => {
      const matchesSearch =
        product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        product.description.toLowerCase().includes(searchTerm.toLowerCase())
      const matchesCategory = selectedCategory === "all" || product.category === selectedCategory
      return matchesSearch && matchesCategory
    })
    .sort((a, b) => {
      switch (sortBy) {
        case "price-asc":
          return a.price - b.price
        case "price-desc":
          return b.price - a.price
        case "rating":
          return b.rating - a.rating
        default:
          return a.name.localeCompare(b.name)
      }
    })

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold mb-4">Tous nos Produits</h1>
        <p className="text-gray-600">Découvrez notre collection complète de {products.length} produits</p>
      </div>

      {/* Filtres et recherche */}
      <div className="bg-white p-6 rounded-lg shadow-sm border mb-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {/* Recherche */}
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <Input
              placeholder="Rechercher..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10"
            />
          </div>

          {/* Catégorie */}
          <Select value={selectedCategory} onValueChange={setSelectedCategory}>
            <SelectTrigger>
              <SelectValue placeholder="Catégorie" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Toutes les catégories</SelectItem>
              {categories.map((category) => (
                <SelectItem key={category.id} value={category.id}>
                  {category.name}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          {/* Tri */}
          <Select value={sortBy} onValueChange={setSortBy}>
            <SelectTrigger>
              <SelectValue placeholder="Trier par" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="name">Nom A-Z</SelectItem>
              <SelectItem value="price-asc">Prix croissant</SelectItem>
              <SelectItem value="price-desc">Prix décroissant</SelectItem>
              <SelectItem value="rating">Mieux notés</SelectItem>
            </SelectContent>
          </Select>

          {/* Bouton reset */}
          <Button
            variant="outline"
            onClick={() => {
              setSearchTerm("")
              setSelectedCategory("all")
              setSortBy("name")
            }}
          >
            <Filter className="h-4 w-4 mr-2" />
            Réinitialiser
          </Button>
        </div>
      </div>

      {/* Résultats */}
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center space-x-2">
          <span className="text-gray-600">
            {filteredProducts.length} produit{filteredProducts.length > 1 ? "s" : ""} trouvé
            {filteredProducts.length > 1 ? "s" : ""}
          </span>
          {selectedCategory !== "all" && (
            <Badge variant="secondary">{categories.find((c) => c.id === selectedCategory)?.name}</Badge>
          )}
          {searchTerm && <Badge variant="secondary">"{searchTerm}"</Badge>}
        </div>
      </div>

      {/* Grille de produits */}
      {filteredProducts.length > 0 ? (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {filteredProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      ) : (
        <div className="text-center py-12">
          <p className="text-gray-500 text-lg mb-4">Aucun produit trouvé</p>
          <Button
            onClick={() => {
              setSearchTerm("")
              setSelectedCategory("all")
            }}
          >
            Voir tous les produits
          </Button>
        </div>
      )}
    </div>
  )
}
