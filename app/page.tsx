import HeroSection from "@/components/hero-section"
import CategoryGrid from "@/components/category-grid"
import ProductCard from "@/components/product-card"
import { Button } from "@/components/ui/button"
import { products } from "@/lib/data"
import Link from "next/link"

export default function HomePage() {
  const featuredProducts = products.slice(0, 4)

  return (
    <>
      <HeroSection />

      <CategoryGrid />

      {/* Produits en vedette */}
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold mb-4">Produits en Vedette</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Découvrez notre sélection de produits populaires et tendances, choisis spécialement pour vous.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {featuredProducts.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>

          <div className="text-center">
            <Link href="/produits">
              <Button size="lg">Voir tous les produits</Button>
            </Link>
          </div>
        </div>
      </section>

      {/* Section promotionnelle */}
      <section className="py-16 bg-blue-600 text-white">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-bold mb-4">Offre Spéciale</h2>
          <p className="text-xl mb-8 text-blue-100">Livraison gratuite sur toutes les commandes de plus de 50€</p>
          <Button size="lg" className="bg-yellow-500 hover:bg-yellow-600 text-black">
            Profiter de l'offre
          </Button>
        </div>
      </section>
    </>
  )
}
