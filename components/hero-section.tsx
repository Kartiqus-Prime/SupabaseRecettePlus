import Image from "next/image"
import { Button } from "@/components/ui/button"
import { ArrowRight } from "lucide-react"

export default function HeroSection() {
  return (
    <section className="bg-gradient-to-r from-blue-600 to-purple-700 text-white">
      <div className="container mx-auto px-4 py-16">
        <div className="grid md:grid-cols-2 gap-8 items-center">
          <div>
            <h1 className="text-4xl md:text-6xl font-bold mb-6">
              Découvrez nos
              <span className="block text-yellow-300">Offres Exceptionnelles</span>
            </h1>
            <p className="text-xl mb-8 text-blue-100">
              Des milliers de produits de qualité à prix imbattables. Livraison gratuite dès 50€ d'achat.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <Button size="lg" className="bg-yellow-500 hover:bg-yellow-600 text-black">
                Découvrir les offres
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="border-white text-white hover:bg-white hover:text-blue-600"
              >
                Voir tous les produits
              </Button>
            </div>
          </div>
          <div className="relative">
            <Image
              src="/placeholder.svg?height=400&width=500"
              alt="Shopping"
              width={500}
              height={400}
              className="rounded-lg shadow-2xl"
            />
          </div>
        </div>
      </div>
    </section>
  )
}
