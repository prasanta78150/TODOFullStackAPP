from contextlib import asynccontextmanager 
from fastapi import FastAPI , Depends, HTTPException , Request ,status 
from sqlalchemy import select 
from sqlalchemy.orm import Session 

from app.database import get_db , Base, engine 
from app.models import Task 
from app.schemas import TaskCreate , TaskUpdate , TaskResponse 


@asynccontextmanager
async def lifespan(app: FastAPI):
    Base.metadata.create_all(bind = engine)
    yield  

app = FastAPI(
    title = "Todo App" ,
    lifespan = lifespan
    )

## Get all tasks 
@app.get("/tasks" , response_model = list[TaskResponse])
def get_tasks(db: Session = Depends(get_db)):
    return db.scalars(
        select(Task).order_by(Task.id)
    ).all()


## Get single task by id 
@app.get("/tasks/{task_id}", response_model = TaskResponse)
def get_task(task_id: int , db: Session = Depends(get_db)):

    task = db.get(Task , task_id)

    if task is None:
        raise HTTPException(
            status_code = 404 , 
            detail = "Task not found"
        )

    return task 


## Post a new task 
@app.post("/tasks" , response_model = TaskResponse , status_code = 201)
def create_task(data:TaskCreate , db: Session = Depends(get_db)):
    task = Task(title = data.title.strip())

    if  not  task.title:
        raise HTTPException(
            status_code = 422,
            detail = "Title cannot be empty"
        )

    db.add(task)
    db.commit()
    db.refresh(task)

    return task 

##update a task by id 
@app.put("/tasks/{task_id}", response_model = TaskResponse)
def update_task(task_id : int , data:TaskUpdate , db: Session = Depends(get_db)):
    task = db.get(Task, task_id)

    if task is None:
        raise HTTPException(
            status_code = 404 , 
            detail = "Task not found"
        )

    updates = data.model_dump(exclude_unset = True)

    

    if "title" in updates:
        if updates["title"] is None:
            raise HTTPException(
                status_code = 422 ,
                detail = "Title cannot be empty"
            )

        updates["title"] = updates["title"].strip()

        for field, value in updates.items():
            setattr(task , field , value)

        db.commit()
        db.refresh(task)

        return task


## Delete a task by id
@app.delete("/tasks/{task_id}" , status_code = 204)
def delete_task(task_id:int , db:Session = Depends(get_db)):
    task = db.get(Task , task_id)

    if task is None:
        raise HTTPException(
            status_code = 404 , 
            detail = "Task not found"
        )

    db.delete(task)
    db.commit()

    return None


