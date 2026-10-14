from datetime import datetime 
from pydantic import BaseModel, Field , ConfigDict 

class TaskCreate(BaseModel):
    title: str = Field( min_length = 1, max_length = 255)

class TaskUpdate(BaseModel):
    title: str | None = Field(
        default = None ,
        min_length = 1 , 
        max_length = 255
    )
    is_completed: bool | None = None 


class TaskResponse(BaseModel):
    model_config = ConfigDict(from_attributes = True)

    id : int
    title : str 
    is_completed : bool
    created_at : datetime 
    






