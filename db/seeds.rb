Category.create([
  { name: "Indústria, Comércio e Emprego" },
  { name: "Ciência e Tecnologia" },
  { name: "Direitos Humanos" },
  { name: "Educação" },
  { name: "Orçamento e Fiscalização Financeira" },
  { name: "Saúde e Drogas" },
  { name: "Crianças e adolescentes" },
  { name: "Pessoas de terceira idade" },
  { name: "Meio Ambiente e Direitos dos Animais" },
  { name: "Defesa do Consumidor" },
  { name: "Obras Públicas e Infraestrutura" },
  { name: "Transportes e Trânsito" },
  { name: "Turismo" },
  { name: "Eleições" },
  { name: "Megaeventos" },
  { name: "Transparência e Participação" },
  { name: "Esportes e Lazer" },
  { name: "Cultura" }
])

# Campaign.create!(
#   ends_at: (i + 10).days.from_now,
#   share_link: "http://minhascidades.org.br",
#   goal: i*10,
#   organization: Organization.first,
#   title: "Campaign #{i}",
#   image: File.new("#{Rails.root}/spec/support/images/whale.jpg"),
#   description: Faker::Lorem.paragraphs(1).join("\n\n"),
#   user: User.first,
#   category: Category.first,
#   short_description: Faker::Lorem.sentence,
#   share_image: File.new("#{Rails.root}/spec/support/images/whale.jpg"),
#   share_title: "Salvem as baleias",
#   share_description: Faker::Lorem.paragraph,
#   tweet: Faker::Lorem.sentence,
#   new_campaign_spreader_mail: Faker::Lorem.paragraph
# )
