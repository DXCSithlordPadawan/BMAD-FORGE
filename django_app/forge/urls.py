"""
BMAD Forge URL Configuration
"""
from django.urls import path
from . import views

app_name = 'forge'

urlpatterns = [
    # Homepage
    path('', views.index, name='index'),
    
    # Templates
    path('templates/', views.template_list, name='template_list'),
    path('templates/<int:template_id>/', views.template_detail, name='template_detail'),
    path('templates/<int:template_id>/generate/', views.generate_document, name='generate_document'),
    
    # Documents
    path('documents/', views.document_list, name='document_list'),
    path('documents/<int:document_id>/', views.document_detail, name='document_detail'),
    path('documents/<int:document_id>/approve/', views.document_approve, name='document_approve'),
    path('documents/<int:document_id>/download/<str:format>/', views.document_download, name='document_download'),
    path('documents/<int:document_id>/delete/', views.document_delete, name='document_delete'),
    
    # API endpoints
    path('api/templates/<int:template_id>/variables/', views.api_template_variables, name='api_template_variables'),
    path('api/validate/', views.api_validate_document, name='api_validate_document'),
]
