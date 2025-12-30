from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

accounts = [
    {
        "username": "login1234", 
        "password": "password1234", 
        "email": "email@example.com"
    },
]

class LoginData(BaseModel):
    username: str
    password: str

@app.post("/login")
def login(data: LoginData):
    for account in accounts:
        if account["username"] == data.username and account["password"] == data.password:
            return {
                "status": "success",
                "username": account["username"],
                "email": account["email"]
            }
    raise HTTPException(status_code=401, detail="Incorrect username or password")
