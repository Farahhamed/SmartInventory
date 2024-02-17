from odoo import api, fields, models

class Logs(models.Model):
    _name = "logs.logs"
    _description = 'Logs'

    # product_id = fields.Many2many(
    #     'product.template',
    #     string='Products',
    #     help='Select the products related to this log'
    # )

    is_entered = fields.Boolean(
        string='Is entered',
        default=True,
    )

    # employee_id = fields.Many2one(
    #     'employees.employees',
    #     string='Employee',
    #     help='Select the employee associated with this log'
    # )
 