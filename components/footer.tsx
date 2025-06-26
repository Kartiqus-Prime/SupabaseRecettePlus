import Link from "next/link"
import { Facebook, Twitter, Instagram, Mail, Phone, MapPin } from "lucide-react"

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-white">
      <div className="container mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {/* Logo et description */}
          <div>
            <h3 className="text-2xl font-bold text-blue-400 mb-4">ShopMart</h3>
            <p className="text-gray-300 mb-4">
              Votre destination shopping en ligne pour des produits de qualité à prix imbattables.
            </p>
            <div className="flex space-x-4">
              <Facebook className="h-5 w-5 text-gray-400 hover:text-blue-400 cursor-pointer" />
              <Twitter className="h-5 w-5 text-gray-400 hover:text-blue-400 cursor-pointer" />
              <Instagram className="h-5 w-5 text-gray-400 hover:text-blue-400 cursor-pointer" />
            </div>
          </div>

          {/* Liens rapides */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Liens Rapides</h4>
            <ul className="space-y-2">
              <li>
                <Link href="/" className="text-gray-300 hover:text-white">
                  Accueil
                </Link>
              </li>
              <li>
                <Link href="/produits" className="text-gray-300 hover:text-white">
                  Produits
                </Link>
              </li>
              <li>
                <Link href="/categories" className="text-gray-300 hover:text-white">
                  Catégories
                </Link>
              </li>
              <li>
                <Link href="/contact" className="text-gray-300 hover:text-white">
                  Contact
                </Link>
              </li>
            </ul>
          </div>

          {/* Service client */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Service Client</h4>
            <ul className="space-y-2">
              <li>
                <Link href="/aide" className="text-gray-300 hover:text-white">
                  Centre d'aide
                </Link>
              </li>
              <li>
                <Link href="/retours" className="text-gray-300 hover:text-white">
                  Retours
                </Link>
              </li>
              <li>
                <Link href="/livraison" className="text-gray-300 hover:text-white">
                  Livraison
                </Link>
              </li>
              <li>
                <Link href="/garantie" className="text-gray-300 hover:text-white">
                  Garantie
                </Link>
              </li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Contact</h4>
            <div className="space-y-3">
              <div className="flex items-center">
                <Phone className="h-4 w-4 mr-2 text-blue-400" />
                <span className="text-gray-300">01 23 45 67 89</span>
              </div>
              <div className="flex items-center">
                <Mail className="h-4 w-4 mr-2 text-blue-400" />
                <span className="text-gray-300">contact@shopmart.fr</span>
              </div>
              <div className="flex items-center">
                <MapPin className="h-4 w-4 mr-2 text-blue-400" />
                <span className="text-gray-300">123 Rue du Commerce, Paris</span>
              </div>
            </div>
          </div>
        </div>

        <div className="border-t border-gray-800 mt-8 pt-8 text-center">
          <p className="text-gray-400">© 2024 ShopMart. Tous droits réservés.</p>
        </div>
      </div>
    </footer>
  )
}
