#!/bin/bash

echo "🚀 Configurando proyecto Django + Supabase + Docker..."

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor, instala Docker primero."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Por favor, instala Docker Compose primero."
    exit 1
fi

# Crear .env si no existe
if [ ! -f .env ]; then
    echo "📝 Creando archivo .env desde template..."
    cp .env.example .env
    echo "⚠️  IMPORTANTE: Edita el archivo .env con las credenciales reales de Supabase"
    echo "   Contacta al administrador del proyecto para obtener las credenciales."
    read -p "   ¿Ya tienes las credenciales en .env? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   Completa el archivo .env y ejecuta este script nuevamente."
        exit 1
    fi
fi

echo "🏗️  Construyendo contenedores..."
docker-compose up --build -d

echo "⏳ Esperando que el contenedor esté listo..."
sleep 5

echo "🔄 Aplicando migraciones..."
docker exec django_app python manage.py migrate

echo "✅ ¡Setup completado!"
echo ""
echo "🌐 Tu aplicación está corriendo en: http://localhost:8000"
echo ""
echo "📝 Comandos útiles:"
echo "   docker-compose logs -f              # Ver logs"
echo "   docker exec -it django_app bash     # Terminal del contenedor"
echo "   docker exec django_app python manage.py shell  # Shell de Django"
echo ""
echo "🛑 Para detener: docker-compose down"