from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.

def home(request):
    # return HttpResponse('<h1>Hello, Django</h1>')
    msg = 'Django'
    return render(request, "home.html", {'m' : msg})