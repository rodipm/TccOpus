from back.app import app
from flask import json

# PROJECT
def test_list_all_projects():
    response = app.test_client().get(
        '/projects?client_email=teste@teste.com',
    )
    data = json.loads(response.get_data(as_text=True))
    assert response.status_code == 200
    assert 'project_names' in data


def test_list_all_projects_invalid_client():
    response = app.test_client().get(
        '/projects?client_email=not_a_client',
    )
    data = json.loads(response.get_data(as_text=True))
    assert response.status_code == 401
    assert 'error' in data
    assert data['error'] == "Invalid Client Email"
    assert 'status' in data
    assert data['status'] == 401
