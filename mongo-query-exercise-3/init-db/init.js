// Selecciona base de datos
db = db.getSiblingDB("testdb");

// Inserta documentos válidos con constructores BSON explícitos
db.orders.insertMany([
  {
    _id: new ObjectId("60b8d295f1a7f2355e9f1d8c"),
    Date: new Date("2024-06-20T15:30:00Z"),
    Amount: 250.75,
    txHash:
      "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890",
  },
  {
    Date: new Date("2024-05-03T10:00:00Z"),
    Amount: 180.0,
    txHash:
      "0x1111111111111111111111111111111111111111111111111111111111111111",
  },
  {
    Date: new Date("2024-05-15T16:45:00Z"),
    Amount: 99.99,
    txHash:
      "0x2222222222222222222222222222222222222222222222222222222222222222",
  },
  {
    Date: new Date("2024-05-25T12:30:00Z"),
    Amount: 320.0,
    txHash:
      "0x3333333333333333333333333333333333333333333333333333333333333333",
  },
  {
    Date: new Date("2024-06-01T08:00:00Z"),
    Amount: 105.5,
    txHash:
      "0x4444444444444444444444444444444444444444444444444444444444444444",
  },
]);
