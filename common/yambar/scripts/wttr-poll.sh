


while true; do
  wttr=$(wttr format="%l:+%c+%t\n")

  echo "wttr|string|$wttr"
  echo ""
  sleep 300
done
