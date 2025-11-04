<?php

namespace App\Http\Controllers;

use App\Http\Requests\TodolistRequest;
use App\Models\Todolist;
use Illuminate\Http\Request;
use Inertia\Inertia;

class TodolistController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {

        $list = Todolist::all();
        return Inertia::render(
            'todolist',['list' => $list]
        );
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(TodolistRequest $request)
    {
    try {
            $todo = Todolist::create($request->validated());

         return redirect()
            ->route('todolist')
            ->with('success', 'Todo created successfully!');
        } catch (\Throwable $th) {
            \Log::error($th->getMessage());

             return redirect()
            ->route('todolist')
            ->with('error', 'Something went wrong. Please try again.');
        }
    }

    /**
     * Display the specified resource.
     */
    public function show(todolist $todolist)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(todolist $todolist)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(TodolistRequest $request,  $id)
    {
        try {
            //code...
            $list = Todolist::find($id);
            $list->update();
      
             return redirect()
            ->route('todolist')
            ->with('success', 'Todo deleted successfully!');
        } catch (\Throwable $th) {
             \Log::error($th->getMessage());
               return redirect()
            ->route('todolist')
            ->with('error', 'Something went wrong. Please try again.');
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Todolist $todolist, $id)
    {
        try {
            //code...
            $list = Todolist::find($id);
            $list->delete();
            
             return redirect()
            ->route('todolist')
            ->with('success', 'Todo deleted successfully!');
        } catch (\Throwable $th) {
             \Log::error($th->getMessage());
               return redirect()
            ->route('todolist')
            ->with('error', 'Something went wrong. Please try again.');
        }
    }
}