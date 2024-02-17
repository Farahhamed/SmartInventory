from flask import jsonify, request
import connection as con

@con.app.route('/get_employees', methods=['GET'])
def get_employees():
    models, db, uid, password = con.connect_to_odoo()
    record_ids = models.execute_kw(db, uid, password, 'hr.employee', 'search', [[]])
    records = models.execute_kw(db, uid, password, 'hr.employee', 'read', [record_ids], {'fields': ['name', 'job_title']})

    return jsonify(records)

@con.app.route('/add_employee', methods=['POST'])
def add_employee():
    try:
        models, db, uid, password = con.connect_to_odoo()

        # Extract product details from the request JSON data
        data = request.json
        employee_name = data.get('name')
        position = data.get('job_title')

        # Create a new product
        new_employee_id = models.execute_kw(
            db, uid, password, 'hr.employee', 'create',
            [{'name': employee_name, 'job_title': position}]
        )

        return jsonify({'status': 'success', 'employee_id': new_employee_id})

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})
    
@con.app.route('/update_employee', methods=['PUT'])
def update_employee():
    try:
        models, db, uid, password = con.connect_to_odoo()

        # Extract product details from the request JSON data
        data = request.json
        employee_id = data.get('employee_id')
        new_name = data.get('new_name')
        new_job_title = data.get('new_job_title')

        # Check if the product exists
        if not models.execute_kw(db, uid, password, 'hr.employee', 'search_count', [[('id', '=', employee_id)]]):
            return jsonify({'status': 'error', 'message': 'Product not found'})

        # Update product details
        models.execute_kw(
            db, uid, password, 'hr.employee', 'write',
            [[employee_id], {'name': new_name, 'list_price': new_job_title}]
        )

        return jsonify({'status': 'success', 'message': 'Product details updated'})

    except Exception as e:
        return jsonify({'status': 'error', 'message': str(e)})
    
@con.app.route('/delete_employee/<int:employee_id>', methods=['DELETE'])
def delete_employee(employee_id):
    models, db, uid, password = con.connect_to_odoo()

    # Check if the product exists
    employee_exists = models.execute_kw(db, uid, password, 'hr.employee', 'search_count', [[('id', '=', employee_id)]])
    if not employee_exists:
        return jsonify({'error': 'Product not found'}), 404

    # Delete the product
    try:
        models.execute_kw(db, uid, password, 'hr.employee', 'unlink', [[employee_id]])
        return jsonify({'message': 'Product deleted successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500
