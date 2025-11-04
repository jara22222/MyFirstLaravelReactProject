<?php

namespace App\Http\Controllers;

use Illuminate\Contracts\Support\Responsable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\View;
use PHPUnit\Framework\TestStatus\TestStatus;
use Response;

class UserController extends Controller
{
    public function index (Request $req){

        $path = $req->fullUrl();

        return $path;
    }

     public function show (){
        return  "asdsadasdasdas";
    }
}