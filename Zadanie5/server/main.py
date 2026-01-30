from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import json
import hashlib

app = FastAPI()

# accounts = [
#     {
#         "username": "login1234", 
#         "password": hashlib.sha256("password1234".encode()).hexdigest(),
#         "email": "email@example.com",
#         "firstName": "Adam",
#         "lastName": "Williams"
#     },
# ]

class LoginData(BaseModel):
    username: str
    password: str

class RegisterData(BaseModel):
    username: str
    password: str
    email: str
    firstName: str
    lastName: str

@app.post("/login")
def login(data: LoginData):
    with open('accounts.json', 'r', encoding='utf-8') as f:
        accounts = json.load(f)
        
    for account in accounts:
        if account["username"] == data.username and account["password"] == hashlib.sha256(data.password.encode()).hexdigest():
            return {
                "status": "success",
                "username": account["username"],
                "email": account["email"],
                "firstName": account["firstName"],
                "lastName": account["lastName"]
            }
    raise HTTPException(status_code=401, detail="Incorrect username or password")


@app.post("/register")
def register(data: RegisterData):
    with open('accounts.json', 'r', encoding='utf-8') as f:
        accounts = json.load(f)
        
    for account in accounts:
        if account["username"] == data.username or account["email"] == data.email:
            raise HTTPException(status_code=409, detail="User already exists")
    
    new_account = {
        "username": data.username,
        "password": hashlib.sha256(data.password.encode()).hexdigest(),
        "email": data.email,
        "firstName": data.firstName,
        "lastName": data.lastName
    }
    accounts.append(new_account)
    with open('accounts.json', 'w', encoding='utf-8') as f:
        json.dump(
            accounts,
            f,
            indent=4
        )
    return {"status": "success", "message": "Account registered successfully"}