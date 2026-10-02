<?php

class VendasResumo extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $pedido;

    /**
     *
     * @var string
     */
    public $data;

    /**
     *
     * @var string
     */
    public $evento;

    /**
     *
     * @var string
     */
    public $pDV;

    /**
     *
     * @var string
     */
    public $terminal;

    /**
     *
     * @var string
     */
    public $pagamento;

    /**
     *
     * @var string
     */
    public $origem;

    /**
     *
     * @var integer
     */
    public $produtos;

    /**
     *
     * @var double
     */
    public $valor_Total;

    /**
     *
     * @var double
     */
    public $valor_Produto;

    /**
     *
     * @var double
     */
    public $valor_Taxa;

    /**
     *
     * @var string
     */
    public $cliente;

    /**
     *
     * @var string
     */
    public $authCode;

    /**
     *
     * @var string
     */
    public $transactionId;

    /**
     * Initialize method for model.
     */
    public function initialize()
    {
        $this->setSchema("ticket");
        $this->setSource("vendas_resumo");
    }


    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'vendas_resumo';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return VendasResumo[]|VendasResumo|\Phalcon\Mvc\Model\ResultSetInterface
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return VendasResumo|\Phalcon\Mvc\Model\ResultInterface
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
