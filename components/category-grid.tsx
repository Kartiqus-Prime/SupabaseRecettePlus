import Image from "next/image"
import Link from "next/link"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { categories } from "@/lib/data"

export default function CategoryGrid() {
  return (
    <section className="py-16 bg-gray-50">
      <div className="container mx-auto px-4">
        <div className="text-center mb-12">
          <h2 className="text-3xl font-bold mb-4">Nos Catégories</h2>
          <p className="text-gray-600 max-w-2xl mx-auto">
            Explorez notre large gamme de produits organisés par catégories pour trouver exactement ce que vous
            cherchez.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {categories.map((category) => (
            <Link key={category.id} href={`/produits?category=${category.id}`}>
              <Card className="group hover:shadow-lg transition-all duration-300 cursor-pointer">
                <CardContent className="p-0">
                  <div className="relative overflow-hidden">
                    <Image
                      src={category.image || "/placeholder.svg"}
                      alt={category.name}
                      width={300}
                      height={200}
                      className="w-full h-40 object-cover group-hover:scale-105 transition-transform duration-300"
                    />
                    <div className="absolute inset-0 bg-black bg-opacity-40 group-hover:bg-opacity-30 transition-all duration-300" />
                    <div className="absolute inset-0 flex flex-col justify-center items-center text-white">
                      <h3 className="text-xl font-bold mb-2">{category.name}</h3>
                      <Badge variant="secondary">{category.productCount} produits</Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      </div>
    </section>
  )
}
