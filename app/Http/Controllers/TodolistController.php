<?php

namespace App\Http\Controllers;

use App\Http\Requests\TodolistRequest;
use App\Models\Todolist;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Log;

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


                $isValidated = $request->validated();


        
                $checkTitle = Todolist::
                    where('title', '=', $isValidated['title'])->exists();

                $checkDescription = Todolist::
                    where('description', '=', $isValidated['description'])->exists();

              
                if ($checkTitle) {
                    Log::error("Title already exists: " . $isValidated['title']);
                    return redirect()
                        ->route('todolist')
                        ->with('titleError', 'Title already exists. Please choose a different title.');

                }

                if ($checkDescription) {
                    Log::error("Description already exists: " . $isValidated['description']);
                    return redirect()
                        ->route('todolist')
                        ->with('descriptionError', 'Description already exists. Please choose a different description.');
                }

                if (!$checkTitle && !$checkDescription) {
                 
                    Todolist::create($request->validated());
                    return redirect()
                        ->route('todolist')
                        ->with('success', 'Todo updated successfully!');


                }
         

        } catch (\Throwable $th) {
            Log::error($th->getMessage());

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
            
            $isValidated = $request->validated();
           
            $list = Todolist::findOrFail($id);


            if ($list) {


                $checkTitle = Todolist::
                    where('title', '=', $isValidated['title'])->exists();

                $checkDescription = Todolist::
                    where('description', '=', $isValidated['description'])->exists();

              
                if ($checkTitle) {
                    Log::error("Title already exists: " . $list->title);
                    return redirect()
                        ->route('todolist')
                        ->with('error', 'Title already exists. Please choose a different title.');

                }

                if ($checkDescription) {
                    Log::error("Description already exists: " . $list->description);
                    return redirect()
                        ->route('todolist')
                        ->with('error', 'Description already exists. Please choose a different description.');
                }

                if (!$checkTitle && !$checkDescription) {
                    $list->update($isValidated);
                    $list->save();
                    return redirect()
                        ->route('todolist')
                        ->with('success', 'Todo updated successfully!');


                }
            }
            
        } catch (\Throwable $th) {
             Log::error($th->getMessage());
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
            $list = Todolist::findOrFail($id);
            $list->delete();
            
             return redirect()
            ->route('todolist')
            ->with('success', 'Todo deleted successfully!');
        } catch (\Throwable $th) {
             Log::error($th->getMessage());
               return redirect()
            ->route('todolist')
            ->with('error', 'Something went wrong. Please try again.');
        }
    }
}